import PDO.*
import PDOLoop.*
import PDOUtils.*
import PDODamageUtils.*
import PDOAudioUtils.*
import PDOLogging.*

/*_______________________________________________________
              
        ADDING NEW FIELD TO GAMEHITEVENT (= PROPERTY)
________________________________________________________*/
@addField(gameHitEvent)
public let isProjection: Bool;

/*_______________________________________________________
              
        ADDING NEW FIELDS TO NPCs (= PROPERTIES)
________________________________________________________*/

@addField(NPCPuppet)
let toBeIncapacitated: Bool;
@addField(NPCPuppet)
let wasInvulnerableAfterDefeat: Bool;
@addField(NPCPuppet)
let wasInvulnerable: Bool;
@addField(NPCPuppet)
let hasBeenAffectedByMod: Bool;
@addField(NPCPuppet)
let lastpainaudio: CName;
@addField(NPCPuppet)
let lastpainvoiceover: CName;
@addField(NPCPuppet)
let timeonfire: Uint32;
@addField(NPCPuppet)
let incburningstarted: Uint32;
@addField(NPCPuppet)
let burningstop: Int32;
@addField(NPCPuppet)
let lasttimefireaudio: Uint32;
@addField(NPCPuppet)
let fireaudiointerval: Int32;
@addField(NPCPuppet)
let lastfireaudio: CName;
@addField(NPCPuppet)
let leftleghitcounter: Int32;
@addField(NPCPuppet)
let rightleghitcounter: Int32;
@addField(NPCPuppet)
let leftarmhitcounter: Int32;
@addField(NPCPuppet)
let rightarmhitcounter: Int32;
@addField(NPCPuppet)
let torsohitcounter: Int32;
@addField(NPCPuppet)
let headhitcounter: Int32;
@addField(NPCPuppet)
let timeincapacitated: Uint32;
@addField(NPCPuppet)
let lasttimemoaned: Uint32;
@addField(NPCPuppet)
let moaninterval: Int32;
@addField(NPCPuppet)
let lastmoanaudio: CName;
@addField(NPCPuppet)
let lasttimebegged: Uint32;
@addField(NPCPuppet)
let begginginterval: Int32;
@addField(NPCPuppet)
let isBoss: Bool;
@addField(NPCPuppet)
let DyingStateForced: Bool;
@addField(NPCPuppet)
let KilledCleanlyCount: Int32;
@addField(NPCPuppet)
let WasPDODismembered: Bool;
@addField(NPCPuppet)
let lasttimescreamed: Uint32;
@addField(NPCPuppet)
let screaminterval: Int32;
@addField(NPCPuppet)
let lastscreamaudio: CName;
@addField(NPCPuppet)
let screamcount: Int32;
@addField(NPCPuppet)
let pdoLoopCounter: Int32;
@addField(NPCPuppet)
let gender: Int32;
//10 = male
//20 = female


/*__________________________________________________________________________________________________________________________________

                        
                                            FLAGGING HIT EVENT, IF ITS NOT A PHYSICAL HIT

__________________________________________________________________________________________________________________________________*/

@wrapMethod(DamageSystem)
private final func ProcessProjectionPipeline(hitEvent: ref<gameProjectedHitEvent>, cache: ref<CacheData>) -> Void {
  let PDO: ref<PedDamageOverhaul2077> = PedDamageOverhaul2077.GetInstance();
  if PDO.GetEnabled() {
    hitEvent.isProjection = true;
  }
  wrappedMethod(hitEvent, cache);
}

/*__________________________________________________________________________________________________________________________________

                        
                                            HOOKING AND TRIGGERING CUSTOM FUNCTION

__________________________________________________________________________________________________________________________________*/

@wrapMethod(DamageSystem)
private func ProcessLocalizedDamage(hitEvent: ref<gameHitEvent>) {
  
  /*_______________________________________________________
              
        GET CLASS INSTANCE, WHICH HOLDS THE MOD SETTING VALUES
  ________________________________________________________*/
  
  let PDO: ref<PedDamageOverhaul2077> = PedDamageOverhaul2077.GetInstance();
  let NPCIsBossAndPDOEnabled: Bool = true;
  let npc: ref<NPCPuppet> = hitEvent.target as NPCPuppet;
  
  if IsDefined(npc) && !npc.IsDead() {
    if DetermineIfNPCIsBossOrPsycho(npc) && !PDO.EnablePDOForBosses {
      NPCIsBossAndPDOEnabled = false;
    }
  }

  /*_______________________________________________________
              
        CALL VANILLA FUNCTION, SO NOTHING IS OVERWRITTEN
  ________________________________________________________*/

  wrappedMethod(hitEvent);
  
  if PDO.GetEnabled() && NPCIsBossAndPDOEnabled {

    /*_______________________________________________________

          IF HIT IS PHYSICAL, DO STUFF
    ________________________________________________________*/

    if !hitEvent.isProjection
    {
      /*_______________________________________________________

            VARIABLES AND ERROR CHECKING FROM VANILLA FUNCTION
      ________________________________________________________*/

      let hitUserData: ref<HitShapeUserDataBase>;
      let hitShapes: array<HitShapeData> = hitEvent.hitRepresentationResult.hitShapes;
      let hitShapeType: EHitShapeType = DamageSystemHelper.GetHitShapeTypeFromData(DamageSystemHelper.GetHitShape(hitEvent));

        /* for information purposes:

                enum EHitShapeType
                {
                  None = -1,
                  Flesh = 0,
                  Metal = 1,
                  Cyberware = 2,
                  Armor = 3
                }
        */

      if !hitEvent.attackData.GetInstigator().IsPlayer() {
        return;
      }

      if AttackData.IsAreaOfEffect(hitEvent.attackData.GetAttackType()) {
        return;
      }

      if ArraySize(hitShapes) > 0 {
        hitUserData = DamageSystemHelper.GetHitShapeUserDataBase(hitShapes[0]);
      }

      if !IsDefined(hitUserData) {
        return;
      }

      /*_______________________________________________________

            CUSTOM CODE
      ________________________________________________________*/

      if IsDefined(npc) && !npc.IsDead() {
        if ((PDO.EnablePDOOnlyForHumans && Equals(npc.GetNPCType(), gamedataNPCType.Human)) || (!PDO.EnablePDOOnlyForHumans)) && !ShouldNPCBeExcluded(npc) {        

          let hitShapeTypeString: String = ToString(hitShapeType); //gives information about actual flesh being hit (or metal, cyberware, armor)
          let player: wref<PlayerPuppet> = GetPlayer(npc.GetGame());

          /*_______________________________________________________

              AUDIBLE HIT REACTIONS
          ________________________________________________________*/

          if Equals(npc.lastpainaudio, n"") {
            npc.lastpainaudio = n"placeholder";
          }
          if Equals(npc.lastfireaudio, n"") {
            npc.lastfireaudio = n"placeholder";
          }
          if Equals(npc.lastmoanaudio, n"") {
          npc.lastmoanaudio = n"placeholder";
          }

          //delaying pain moaning when audible reaction to being is played (so they dont overlap)
          if npc.lasttimemoaned > Cast<Uint32>(0) {
            npc.lasttimemoaned = npc.timeincapacitated;
          }
          if PDO.PlayPainSounds {
            PlaySound(npc, GetPainAudio(npc.lastpainaudio, npc));
          }    
          
          /*_______________________________________________________

              ACTIVATING MOD LOOP FOR NPC
          ________________________________________________________*/

          if !npc.hasBeenAffectedByMod {
            if !npc.WasJustKilledOrDefeated() {

              let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(GetGameInstance());
              if statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.InvulnerableAfterDefeated") {
                npc.wasInvulnerableAfterDefeat = true;
              }
              else {
                if statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Invulnerable") {
                  npc.wasInvulnerable = true;
                }
              }          

              DoDamageEffectCalculations(npc, hitUserData, hitShapeTypeString, hitEvent);
              ApplyDamageEffects(npc);
              if (GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold())) && PDO.EnableGore {
                DismemberBodyPart(npc, hitUserData, hitShapeTypeString, hitEvent, 2);
              }

              let myFunctionCallback: ref<DelayedMainLoopCallback> = new DelayedMainLoopCallback();
              myFunctionCallback.entity = npc;
              GameInstance.GetDelaySystem(npc.GetGame()).DelayCallback(myFunctionCallback, 0);
            }
          }
          else {
            DoDamageEffectCalculations(npc, hitUserData, hitShapeTypeString, hitEvent);
            ApplyDamageEffects(npc);
            if (GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold())) && PDO.EnableGore {
              DismemberBodyPart(npc, hitUserData, hitShapeTypeString, hitEvent, 2);
            }
          }

          if npc.headhitcounter >= PDO.GetDSHeadshotKillThreshold() && GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold()) {
            if !DetermineIfNPCIsBossOrPsycho(npc) {
              KillNPCCleanlyModal(npc, 2);
              DismemberBodyPart(npc, hitUserData, hitShapeTypeString, hitEvent, 1);
              player.GetStimBroadcasterComponent().TriggerSingleBroadcast(player, gamedataStimType.Terror, 1.00);
            }
          }
          else {
            if npc.torsohitcounter >= PDO.GetDSTorsoshotKillThreshold() && GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold()) {
              if !DetermineIfNPCIsBossOrPsycho(npc) {
                KillNPCCleanlyModal(npc, 2);
                DismemberBodyPart(npc, hitUserData, hitShapeTypeString, hitEvent, 1);
                player.GetStimBroadcasterComponent().TriggerSingleBroadcast(player, gamedataStimType.Terror, 1.00);
              }
            }
          }
          if PDO.Logging {
            LogNPCData(npc, hitEvent, "Ped Damage Overhaul 2077 - Pre-Shot-Analytics", "Logs the state of the NPC at the moment the damage hits them (status effects, etc. not applied at this time).");
          }  
        }
      }
      else if IsDefined(npc) && npc.IsDead() && PDO.EnableGore {
        let hitShapeTypeString: String = ToString(hitShapeType); //gives information about actual flesh being hit (or metal, cyberware, armor)
        DismemberBodyPart(npc, hitUserData, hitShapeTypeString, hitEvent, 2);
      }
    }
  }
}



/*__________________________________________________________________________________________________________________________________

                        
                                            CUSTOM CLASSES (Callbacks)

__________________________________________________________________________________________________________________________________*/

public class DelayedMainLoopCallback extends DelayCallback {
	public let entity: ref<NPCPuppet>;

  public func Call() -> Void {
		MainLoop(this.entity);
	}
}

public class DelayedResetBloodPuddlePropertiesCallback extends DelayCallback {
  public let entity: ref<NPCPuppet>;

  public func Call() -> Void {
		ResetBloodPuddleProperties(this.entity);
	}
}


/*__________________________________________________________________________________________________________________________________

                        
                                            MAKING SURE RAGDOLLED NPCs DONT GET UP (NOT USED)

__________________________________________________________________________________________________________________________________*/

/*
@wrapMethod(AIRagdollDelegate)
private final func HasSpaceToRecover(owner: ref<NPCPuppet>, queryDimensions: array<Float>, originTransform: WorldTransform) -> Bool {
  if owner.toBeIncapacitated {
    this.poseAllowsRecovery = false;
    return false;
  }
  else {
    return wrappedMethod(owner, queryDimensions, originTransform);
  }
}

@wrapMethod(AIRagdollDelegate)
public final func DoCheckIfPoseAllowsRecovery(context: ScriptExecutionContext) -> Bool {
  let owner: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
  if owner.toBeIncapacitated {
    this.poseAllowsRecovery = false;
    return false;
  }
  else {
    return wrappedMethod(context);
  }
}

@wrapMethod(AIRagdollDelegate)
public final func DoClearActiveStatusEffect(context: ScriptExecutionContext) -> Bool {
  let owner: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
  if owner.toBeIncapacitated {
    this.poseAllowsRecovery = false;
    return wrappedMethod(context);
  }
  else {
    return wrappedMethod(context);
  }
}

@wrapMethod(AIRagdollDelegate)
public final func DoHandleDownedSignals(context: ScriptExecutionContext) -> Bool {
  let owner: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
  if owner.toBeIncapacitated {
    this.poseAllowsRecovery = false;
    return wrappedMethod(context);
  }
  else {
    return wrappedMethod(context);
  }
}
*/

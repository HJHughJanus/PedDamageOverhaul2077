import PDOUtils.*

public class PedDamageOverhaul2077 extends IScriptable {
  public static func GetInstance() -> ref<PedDamageOverhaul2077> {
    let PDO = new PedDamageOverhaul2077();
    return PDO;
  };

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Enabled")
  @runtimeProperty("ModSettings.description", "Enables/Disables Ped Damage Overhaul 2077.")
  let Enabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Enable Only For Human NPCs")
  @runtimeProperty("ModSettings.description", "Makes PDO only work for human NPCs (if this is disabled, some missions may be bugged, since drones or other enemies can be defeated faster than intended).")
  let EnablePDOOnlyForHumans: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Dying State Threshold")
  @runtimeProperty("ModSettings.description", "Health percentage threshold, under which NPCs will go into the Dying State (= incapacitated on the ground, still alive).")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let DyingStateThreshold: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "'Shot Points': Flesh")
  @runtimeProperty("ModSettings.description", "The amount of 'Shot Points' a body part receives when flesh of that body part is hit.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  let FleshHitValue: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "'Shot Points': Metal")
  @runtimeProperty("ModSettings.description", "The amount of 'Shot Points' a body part receives when metal of that body part is hit.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  let MetalHitValue: Int32 = 3;
  
  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "'Shot Points': CyberWare")
  @runtimeProperty("ModSettings.description", "The amount of 'Shot Points' a body part receives when CyberWare of that body part is hit.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  let CyberwareHitValue: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "'Shot Points': Armor")
  @runtimeProperty("ModSettings.description", "The amount of 'Shot Points' a body part receives when armor of that body part is hit.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  let ArmorHitValue: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Enable Head-'Shot Points'")
  @runtimeProperty("ModSettings.description", "If set to False, the 'Shot Point' mechanic will not work for head shots.")
  let HeadshotsKill: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Enable Head Shot Kills with Blunt Weapons")
  @runtimeProperty("ModSettings.description", "If set to False, blunt weapons will not kill an NPC by 'head shot' when the 'Shot Point' mechanic usually would.")
  let HeadShotsWithBluntWeapons: Bool = false;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Head Shot Kill Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to kill an NPC by head shots. (as an NPC enters the Dying State, the head 'Shot Points' get reset to 0) Only works if 'Enable Head-'Shot Points'' is enabled.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  let HeadshotKillThreshold: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Torso Shot Kill Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to kill an NPC by torso thots. (as an NPC enters the Dying State, the horso 'Shot Points' get reset to 0)")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  let TorsoshotKillThreshold: Int32 = 30;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Arm Shot Crippling Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to cripple an NPC's arm.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  let ArmDamagedThreshold: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Leg Shot Crippling Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to cripple an NPC's leg.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  let LegDamagedThreshold: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Torso Shot Crippling Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to cripple an NPC's torso.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  let TorsoDamagedThreshold: Int32 = 15;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Logging")
  @runtimeProperty("ModSettings.description", "Enables/Disables the logging of NPC information into the CET console and log file (this information can be useful when reporting unwanted mod behavior).")
  let Logging: Bool = true;
  

  public func GetEnabled() -> Bool {
    return this.Enabled;
  }

  public func GetDyingStateThreshold() -> Int32 {
    return this.DyingStateThreshold;
  }

  public func GetHeadshotsKill() -> Bool {
    return this.HeadshotsKill;
  }

  public func GetTorsoshotKillThreshold() -> Int32 {
    return this.TorsoshotKillThreshold;
  }

  public func GetHeadshotKillThreshold() -> Int32 {
    return this.HeadshotKillThreshold;
  }

  public func GetArmDamagedThreshold() -> Int32 {
    return this.ArmDamagedThreshold;
  }

  public func GetLegDamagedThreshold() -> Int32 {
    return this.LegDamagedThreshold;
  }

  public func GetTorsoDamagedThreshold() -> Int32 {
    return this.TorsoDamagedThreshold;
  }

  public func GetFleshHitValue() -> Int32 {
    return this.FleshHitValue;
  }
  
  public func GetMetalHitValue() -> Int32 {
    return this.MetalHitValue;
  }

  public func GetCyberwareHitValue() -> Int32 {
    return this.CyberwareHitValue;
  }

  public func GetArmorHitValue() -> Int32 {
    return this.ArmorHitValue;
  }

  public func GetArmorHitValue() -> Int32 {
    return this.ArmorHitValue;
  }
}

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

  /*_______________________________________________________
              
        CALL VANILLA FUNCTION, SO NOTHING IS OVERWRITTEN
  ________________________________________________________*/

  wrappedMethod(hitEvent);
  
  if PDO.GetEnabled() {

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

      let npc: ref<NPCPuppet> = hitEvent.target as NPCPuppet;
      if IsDefined(npc) && !npc.IsDead() {
        if (PDO.EnablePDOOnlyForHumans && Equals(npc.GetNPCType(), gamedataNPCType.Human)) || (!PDO.EnablePDOOnlyForHumans) {        
        
          let hitShapeTypeString: String = ToString(hitShapeType); //gives information about actual flesh being hit (or metal, cyberware, armor)

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
          PlaySound(npc, GetPainAudio(npc.lastpainaudio, npc));    

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

              DoDamageEffectCalculations(npc, hitUserData, hitShapeTypeString);
              ApplyDamageEffects(npc);    

              let myFunctionCallback: ref<DelayedMainLoopCallback> = new DelayedMainLoopCallback();
              myFunctionCallback.entity = npc;
              GameInstance.GetDelaySystem(npc.GetGame()).DelayCallback(myFunctionCallback, 0);
            }
          }
          else {
            DoDamageEffectCalculations(npc, hitUserData, hitShapeTypeString);
            ApplyDamageEffects(npc);
          }
          if PDO.Logging {
            LogChannel(n"DEBUG", "PDO- [PDO 2077] ");
            LogChannel(n"DEBUG", "PDO-    Entity ID: " + ToString(npc.GetEntityID()));
            LogChannel(n"DEBUG", "PDO-    Entity Model/Appearance: " + ToString(npc.GetCurrentAppearanceName()));
            LogChannel(n"DEBUG", "PDO-    To Be Incapacitated: " + ToString(npc.toBeIncapacitated));
            LogChannel(n"DEBUG", "PDO-    Health in Percent: " + ToString(GetNPCHealthInPercent(npc)));
            LogChannel(n"DEBUG", "PDO-    Dying State Threshold (Incapacitation): " + ToString(Cast<Float>(PDO.GetDyingStateThreshold())));
            LogChannel(n"DEBUG", "PDO- ");
            LogChannel(n"DEBUG", "PDO-     - Hit Type: " + ToString(hitShapeType));
            LogChannel(n"DEBUG", "PDO- ");
            LogChannel(n"DEBUG", "PDO-     - Headshot count: " + ToString(npc.headhitcounter));
            LogChannel(n"DEBUG", "PDO-     - - Headshot Kill Threshold: " + ToString(PDO.GetHeadshotKillThreshold()));
            LogChannel(n"DEBUG", "PDO- ");
            LogChannel(n"DEBUG", "PDO-     - Torsoshot count: " + ToString(npc.torsohitcounter));
            LogChannel(n"DEBUG", "PDO-     - - Torso Crippling Threshold: " + ToString(PDO.GetTorsoDamagedThreshold()));
            LogChannel(n"DEBUG", "PDO-     - - Torso Kill Threshold: " + ToString(PDO.GetTorsoshotKillThreshold()));
            LogChannel(n"DEBUG", "PDO- ");
            LogChannel(n"DEBUG", "PDO-     - Right Arm shot count: " + ToString(npc.rightarmhitcounter));
            LogChannel(n"DEBUG", "PDO-     - Left Arm shot count: " + ToString(npc.leftarmhitcounter));
            LogChannel(n"DEBUG", "PDO-     - - Arm Crippling Threshold: " + ToString(PDO.GetArmDamagedThreshold()));
            LogChannel(n"DEBUG", "PDO- ");
            LogChannel(n"DEBUG", "PDO-     - Right Leg shot count: " + ToString(npc.rightleghitcounter));
            LogChannel(n"DEBUG", "PDO-     - Left Leg shot count: " + ToString(npc.leftleghitcounter));
            LogChannel(n"DEBUG", "PDO-     - - Leg Crippling Threshold: " + ToString(PDO.GetLegDamagedThreshold()));
          }  
        }
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

                        
                                            CUSTOM FUNCTION

__________________________________________________________________________________________________________________________________*/


private func ResetBloodPuddleProperties(npc: ref<NPCPuppet>) {
  npc.m_shouldSpawnBloodPuddle = false;
  npc.m_bloodPuddleSpawned = false;
}

private func MainLoop(npc: ref<NPCPuppet>) {

  let mainLoopCallback: ref<DelayedMainLoopCallback> = new DelayedMainLoopCallback();
  mainLoopCallback.entity = npc;
  if IsDefined(npc) && !npc.IsDead(){
  
    let PDO: ref<PedDamageOverhaul2077> = PedDamageOverhaul2077.GetInstance();
    npc.hasBeenAffectedByMod = true;
    //let player: ref<PlayerPuppet> = GetPlayer(npc.GetGame());
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(GetGameInstance());
    
    /*_______________________________________________________
              
              FIRE AUDIO AND LONGER BURNING
    ________________________________________________________*/

    if /*statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Burning") ||  
    statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.LightBurning") ||
    statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.MediumBurning") ||
    statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.StackableMediumBurning") ||*/
    StatusEffectSystem.ObjectHasStatusEffect(npc, t"BaseStatusEffect.Burning") {
      if npc.timeonfire <= Cast<Uint32>(0) {
        npc.timeonfire = Cast<Uint32>(1);
        npc.lasttimefireaudio = Cast<Uint32>(1);
        npc.fireaudiointerval = 38;
        PlaySound(npc, GetFireAudio(npc.lastfireaudio, npc));
      }
      else {
        npc.timeonfire = npc.timeonfire + Cast<Uint32>(1);
        if (npc.lasttimefireaudio + Cast<Uint32>(npc.fireaudiointerval)) < npc.timeonfire {
          npc.lasttimefireaudio = npc.timeonfire;
          PlaySound(npc, GetFireAudio(npc.lastfireaudio, npc));
        }
        if GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold()) {
          if npc.burningstop != 1 {
            GameInstance.GetStatusEffectSystem(npc.GetGame()).SetStatusEffectRemainingDuration(npc.GetEntityID(), t"BaseStatusEffect.Burning", 10.0);
          }
          if npc.incburningstarted <= Cast<Uint32>(0) {
            npc.incburningstarted = Cast<Uint32>(1);
          }
          else {
            npc.incburningstarted = npc.incburningstarted + Cast<Uint32>(1);
          }

          if npc.incburningstarted >= Cast<Uint32>(800) && !npc.wasInvulnerable && !npc.wasInvulnerableAfterDefeat {
            KillNPCCleanly(npc);
            npc.burningstop = 1;
          }
        }
      }
    }
    else {
      npc.timeonfire = Cast<Uint32>(0);
    }    

    /*_______________________________________________________
              
              BODY PART DAMAGE EFFECTS
    ________________________________________________________*/

    if (GetNPCHealthInPercent(npc) > Cast<Float>(PDO.GetDyingStateThreshold())) {
      ApplyDamageEffects(npc);
      GameInstance.GetDelaySystem(npc.GetGame()).DelayCallback(mainLoopCallback, 0);
    }

    /*_______________________________________________________
              
              INCAPACITATION
    ________________________________________________________*/

    else {
      if !npc.toBeIncapacitated {
        npc.toBeIncapacitated = true;
        npc.torsohitcounter = 0;
        npc.headhitcounter = 0;
        npc.timeincapacitated = Cast<Uint32>(1);
        npc.lasttimemoaned = Cast<Uint32>(0);
        npc.moaninterval = 120;
        npc.lasttimebegged = Cast<Uint32>(0);
        npc.begginginterval = 150;
      }

      if npc.toBeIncapacitated {
        npc.timeincapacitated = npc.timeincapacitated + Cast<Uint32>(1);

        if (npc.lasttimebegged + Cast<Uint32>(npc.begginginterval)) < npc.timeincapacitated && !StatusEffectSystem.ObjectHasStatusEffect(npc, t"BaseStatusEffect.Burning") && IsPlayerLookingAtNPC(npc) {
          npc.lasttimebegged = npc.timeincapacitated;
          npc.lasttimemoaned = npc.timeincapacitated;
          PlayVoiceOver(npc, n"fear_beg");
          //n"fear_beg"
          //n"fear_run")
        }

        if (npc.lasttimemoaned + Cast<Uint32>(npc.moaninterval)) < npc.timeincapacitated && !StatusEffectSystem.ObjectHasStatusEffect(npc, t"BaseStatusEffect.Burning") {
          npc.lasttimemoaned = npc.timeincapacitated;
          let randomnr = RandRange(1, 10);
          if randomnr < 5 {
            PlaySound(npc, GetMoanAudio(npc.lastmoanaudio, npc));
          }
        }

        npc.DropHeldItems();

        if (npc.headhitcounter >= PDO.GetHeadshotKillThreshold()) || (npc.torsohitcounter >= PDO.GetTorsoshotKillThreshold()) {
          if !(npc.GetHitReactionComponent().GetHitStimEvent().hitSource == EnumInt(EAIHitSource.MeleeBlunt) && !PDO.HeadShotsWithBluntWeapons) {
            KillNPCCleanly(npc);
          }
          return;
        }

        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.InvulnerableAfterDefeated") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.InvulnerableAfterDefeated", 0.10);
        }
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Invulnerable") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Invulnerable", 0.10);
        }
        SenseComponent.RequestSecondaryPresetChange(npc, t"Senses.Blind");
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Defeated") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Defeated", 0.10);
        }
        
        GameInstance.GetDelaySystem(npc.GetGame()).DelayCallback(mainLoopCallback, 0);
      }
    }
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


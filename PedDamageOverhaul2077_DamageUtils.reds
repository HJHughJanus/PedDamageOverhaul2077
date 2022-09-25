module PDODamageUtils

import PDO.*
import PDOUtils.*

public func DoDamageEffectCalculations(npc: ref<NPCPuppet>, hitUserData: ref<HitShapeUserDataBase>, hitShapeTypeString: String, hitEvent: ref<gameHitEvent>) {
    //let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(GetGameInstance());
    let player: wref<PlayerPuppet> = GetPlayer(npc.GetGame());
    let hitValue: Int32;
    let PDO: ref<PedDamageOverhaul2077> = PedDamageOverhaul2077.GetInstance();
    let attackData: ref<AttackData> = hitEvent.attackData;
    let isBluntAttack: Bool = Equals(RPGManager.GetWeaponEvolution(attackData.GetWeapon().GetItemID()), gamedataWeaponEvolution.Blunt);
    let isBladeAttack: Bool = Equals(RPGManager.GetWeaponEvolution(attackData.GetWeapon().GetItemID()), gamedataWeaponEvolution.Blade);
    let isSilencedAttack: Bool = ScriptedPuppet.GetActiveWeapon(player).IsSilenced();
    let CurrentAttackIsViableHeadshot: Bool = true;
    let CurrentAttackIsViableCripplingShot: Bool = true;

    if isBluntAttack {
        if !PDO.HeadShotsWithBluntWeapons {
            CurrentAttackIsViableHeadshot = false;
        }
        if !PDO.CripplingWithBluntWeapons {
            CurrentAttackIsViableCripplingShot = false;
        }
    }
    else {
        if isBladeAttack {
            if !PDO.HeadShotsWithBladeWeapons {
                CurrentAttackIsViableHeadshot = false;
            }
            if !PDO.CripplingWithBladeWeapons {
                CurrentAttackIsViableCripplingShot = false;
            }
        }
    }

    if isSilencedAttack {
        if !PDO.HeadShotsWithSilencedWeapons {
            CurrentAttackIsViableHeadshot = false;
        }
        if !PDO.CripplingWithSilencedWeapons {
            CurrentAttackIsViableCripplingShot = false;
        }
    }


    switch (hitShapeTypeString) {
        case "Flesh":
            hitValue = PDO.GetFleshHitValue();
            break;
        case "Metal":
            hitValue = PDO.GetMetalHitValue();
            break;
        case "Cyberware":
            hitValue = PDO.GetCyberwareHitValue();
            break;
        case "Armor":
            hitValue = PDO.GetArmorHitValue();
            break;
        default:
            hitValue = 0;
    }

    if HitShapeUserDataBase.IsHitReactionZoneHead(hitUserData) {
        if CurrentAttackIsViableHeadshot {
            npc.headhitcounter = npc.headhitcounter + hitValue;
        }
    }
    else {
        if HitShapeUserDataBase.IsHitReactionZoneTorso(hitUserData) {
            if CurrentAttackIsViableCripplingShot {
                npc.torsohitcounter = npc.torsohitcounter + hitValue;
            }
        }
        else {
            if HitShapeUserDataBase.IsHitReactionZoneLeftArm(hitUserData) {
              if CurrentAttackIsViableCripplingShot && PDO.CripplingArms {
                npc.leftarmhitcounter = npc.leftarmhitcounter + hitValue;
              }
            }
            else {
                if HitShapeUserDataBase.IsHitReactionZoneRightArm(hitUserData) {
                    if CurrentAttackIsViableCripplingShot && PDO.CripplingArms {
                        npc.rightarmhitcounter = npc.rightarmhitcounter + hitValue;
                    }
                }
                else {
                    if HitShapeUserDataBase.IsHitReactionZoneRightLeg(hitUserData) {
                        if CurrentAttackIsViableCripplingShot {
                            npc.rightleghitcounter = npc.rightleghitcounter + hitValue;
                        }
                    }
                    else {
                        if HitShapeUserDataBase.IsHitReactionZoneLeftLeg(hitUserData) {
                            if CurrentAttackIsViableCripplingShot {
                                npc.leftleghitcounter = npc.leftleghitcounter + hitValue;
                            }                       
                        }
                    }
                }
            }
        }
    }
}

public func ApplyDamageEffects(npc: ref<NPCPuppet>) {
    let PDO: ref<PedDamageOverhaul2077> = PedDamageOverhaul2077.GetInstance();
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(GetGameInstance());
    let NPCisMeleeNPC: Bool = WeaponObject.IsMelee(ScriptedPuppet.GetActiveWeapon(npc).GetItemID()) && PDO.DisableCripplingMeleeEnemies;
    if npc.leftarmhitcounter >= PDO.GetArmDamagedThreshold() && !NPCisMeleeNPC {
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledArmLeft") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledHandLeft") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledArmLeft", 0.10);
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledHandLeft", 0.10);
        }
    }
    if npc.rightarmhitcounter >= PDO.GetArmDamagedThreshold() && !NPCisMeleeNPC {
        /* crippling the right arm introduces weird npc behavior -> left arm is being crippled
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledArmRight") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledHandRight") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledArmRight", 0.10);
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledHandRight", 0.10);
        }
        */
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledArmLeft") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledHandLeft") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledArmLeft", 0.10);
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledHandLeft", 0.10);
        }
    }
    if npc.leftleghitcounter >= PDO.GetLegDamagedThreshold() && !NPCisMeleeNPC{
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledLegLeft") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledLegLeft", 0.10);
        }
    }
    if npc.rightleghitcounter >= PDO.GetLegDamagedThreshold() && !NPCisMeleeNPC{
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledLegRight") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledLegRight", 0.10);
        }
    }
    if npc.torsohitcounter >= PDO.GetTorsoDamagedThreshold() && !NPCisMeleeNPC {
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Crippled") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Wounded") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Crippled", 0.10);
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Wounded", 0.10);
        }
    }
    if npc.headhitcounter >= PDO.GetDSHeadshotKillThreshold() && GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold()) {
        if !DetermineIfNPCIsBossOrPsycho(npc) {
            KillNPCCleanly(npc, 1);          
        }
    }
    else {
        if npc.torsohitcounter >= PDO.GetDSTorsoshotKillThreshold() && GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold()) {
            if !DetermineIfNPCIsBossOrPsycho(npc) {
                KillNPCCleanly(npc, 1);          
            }
        }
        else {
            if npc.headhitcounter >= PDO.GetHeadshotKillThreshold() && PDO.GetHeadshotsKill() {
                if !DetermineIfNPCIsBossOrPsycho(npc) {
                    DefeatNPCCleanly(npc);
                    if !npc.hasBeenAffectedByMod {
                        DefeatNPCCleanly(npc);
                    }
                    else {
                        if GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold()) {
                            KillNPCCleanly(npc, 1);
                        }
                        else {
                            DefeatNPCCleanly(npc);
                        }  
                    }
                }
            }
            if npc.torsohitcounter >= PDO.GetTorsoshotKillThreshold() && PDO.GetHeadshotsKill() {
                if !DetermineIfNPCIsBossOrPsycho(npc) {
                    if GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold()) {
                        KillNPCCleanly(npc, 1);
                    }
                    else {
                        DefeatNPCCleanly(npc);
                    }  
                }
            }
            if NPCisMeleeNPC && PDO.CripplingPutsMeleeNPCsDown {
                if (npc.rightleghitcounter >= PDO.GetLegDamagedThreshold() && npc.leftleghitcounter >= PDO.GetLegDamagedThreshold()) || (npc.rightarmhitcounter >= PDO.GetArmDamagedThreshold() && npc.leftarmhitcounter >= PDO.GetArmDamagedThreshold()) {
                    if PDO.CripplingPutsNPCsDown1 && !npc.DyingStateForced{
                        SetNPCHealthInPercent(npc, Cast<Float>(PDO.DyingStateThreshold));
                        npc.DyingStateForced = true;
                    }
                }
                else {
                    if npc.rightleghitcounter >= PDO.GetLegDamagedThreshold() && npc.leftleghitcounter >= PDO.GetLegDamagedThreshold() {
                        if statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledLegLeft") {
                            StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.CrippledLegLeft");
                        }
                        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Crippled") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Wounded") {
                            StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Crippled", 0.10);
                            StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Wounded", 0.10);
                        }
                    }
                    if npc.rightarmhitcounter >= PDO.GetArmDamagedThreshold() && npc.leftarmhitcounter >= PDO.GetArmDamagedThreshold() {
                        if statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledArmRight"){
                            StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.CrippledArmRight");
                        }
                        if statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledHandRight") {
                            StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.CrippledHandRight");
                        }
                        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Crippled") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Wounded") {
                            StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Crippled", 0.10);
                            StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Wounded", 0.10);
                        }
                    }
                }
            }
            else {
                if PDO.CripplingPutsNPCsDown1 || PDO.CripplingPutsNPCsDown2 {
                    if (npc.rightleghitcounter >= PDO.GetLegDamagedThreshold() && npc.leftleghitcounter >= PDO.GetLegDamagedThreshold()) && (npc.rightarmhitcounter >= PDO.GetArmDamagedThreshold() && npc.leftarmhitcounter >= PDO.GetArmDamagedThreshold()) {
                        if PDO.CripplingPutsNPCsDown1 && !npc.DyingStateForced {
                            SetNPCHealthInPercent(npc, Cast<Float>(PDO.DyingStateThreshold));
                            npc.DyingStateForced = true;
                        }
                        else {
                            if PDO.CripplingPutsNPCsDown2 && !npc.DyingStateForced{
                                SetNPCHealthInPercent(npc, Cast<Float>(PDO.DyingStateThreshold));
                                npc.DyingStateForced = true;
                            }
                        }
                    }
                    else {
                        if (npc.rightleghitcounter >= PDO.GetLegDamagedThreshold() && npc.leftleghitcounter >= PDO.GetLegDamagedThreshold()) || (npc.rightarmhitcounter >= PDO.GetArmDamagedThreshold() && npc.leftarmhitcounter >= PDO.GetArmDamagedThreshold()) {
                            if PDO.CripplingPutsNPCsDown1 && !npc.DyingStateForced{
                                SetNPCHealthInPercent(npc, Cast<Float>(PDO.DyingStateThreshold));
                                npc.DyingStateForced = true;
                            }
                        }
                    }
                }
                //Preventing all limbs of being damaged (this would result in NPCs just standing there doing nothing)
                else {
                    if npc.rightleghitcounter >= PDO.GetLegDamagedThreshold() && npc.leftleghitcounter >= PDO.GetLegDamagedThreshold() {
                        if statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledLegLeft") {
                            StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.CrippledLegLeft");
                        }
                        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Crippled") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Wounded") {
                            StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Crippled", 0.10);
                            StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Wounded", 0.10);
                        }
                    }
                    if npc.rightarmhitcounter >= PDO.GetArmDamagedThreshold() && npc.leftarmhitcounter >= PDO.GetArmDamagedThreshold() {
                        if statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledArmRight"){
                            StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.CrippledArmRight");
                        }
                        if statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledHandRight") {
                            StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.CrippledHandRight");
                        }
                        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Crippled") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Wounded") {
                            StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Crippled", 0.10);
                            StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Wounded", 0.10);
                        }
                    }
                }
            }
        }
    }
}

public func DismemberBodyPart(npc: ref<NPCPuppet>, hitUserData: ref<HitShapeUserDataBase>, hitShapeTypeString: String, hitEvent: ref<gameHitEvent>, mode: Int32) {
    //Mode 1 = dismember everything
    //Mode 2 = do not dismember the head
    let dismemberedBodypart: gameDismBodyPart;
    let woundType: gameDismWoundType;
    let attackData: ref<AttackData> = hitEvent.attackData;
    let isBladeAttack: Bool = Equals(RPGManager.GetWeaponEvolution(attackData.GetWeapon().GetItemID()), gamedataWeaponEvolution.Blade);
    let dismFound: Bool = false;


    if isBladeAttack {
        woundType = gameDismWoundType.CLEAN;
    }
    else {
        woundType = gameDismWoundType.COARSE;    
    }

    /*
    enum gameDismBodyPart
    {
        LEFT_LEG = 896,
        RIGHT_LEG = 7168,
        LEFT_ARM = 14,
        RIGHT_ARM = 112,
        HEAD = 1,
        BODY = 8192
    }
    enum gameDismWoundType
    {
        CLEAN = 1,
        COARSE = 2,
        HOLE = 64
    }
    */

    if HitShapeUserDataBase.IsHitReactionZoneHead(hitUserData) && mode == 1 {
        dismemberedBodypart = gameDismBodyPart.HEAD;
        dismFound = true;
    }
    else {
        if HitShapeUserDataBase.IsHitReactionZoneTorso(hitUserData) {
            dismemberedBodypart = gameDismBodyPart.BODY;
            dismFound = true;
        }
        else {
            if HitShapeUserDataBase.IsHitReactionZoneLeftArm(hitUserData) {
              dismemberedBodypart = gameDismBodyPart.LEFT_ARM;
              dismFound = true;
            }
            else {
                if HitShapeUserDataBase.IsHitReactionZoneRightArm(hitUserData) {
                    dismemberedBodypart = gameDismBodyPart.RIGHT_ARM;
                    dismFound = true;
                }
                else {
                    if HitShapeUserDataBase.IsHitReactionZoneRightLeg(hitUserData) {
                        dismemberedBodypart = gameDismBodyPart.RIGHT_LEG;
                        dismFound = true;
                    }
                    else {
                        if HitShapeUserDataBase.IsHitReactionZoneLeftLeg(hitUserData) {
                            dismemberedBodypart = gameDismBodyPart.LEFT_LEG;
                            dismFound = true;                    
                        }
                    }
                }
            }
        }
    }
    
    if dismFound {
        DismembermentComponent.RequestDismemberment(npc, dismemberedBodypart, woundType, Vector4.EmptyVector());//this.m_hitShapeData.result.hitPositionEnter);
        npc.WasPDODismembered = true;
    }
}

public func KillNPCCleanly(npc: ref<NPCPuppet>, mode: Int32) {
    //Mode 1 = use game system for kill
    //Mode 2 = force ragdoll death
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(GetGameInstance());
    if !npc.wasInvulnerable {
        if statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Invulnerable") {
            StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.Invulnerable");
        }
    }
    if !npc.wasInvulnerableAfterDefeat {
        if statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.InvulnerableAfterDefeated") {
            StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.InvulnerableAfterDefeated");
        }
    }
    //blablaset
    npc.SetMyKiller(GetPlayer(npc.GetGame()));
    RagdollNPC(npc, "0");
    SetNPCHealthInPercent(npc, 0);
    /*
    if mode == 1 { //use game system for kill
        if npc.KilledCleanlyCount < 2 {
            npc.SetMyKiller(GetPlayer(npc.GetGame()));
            npc.MarkForDeath();        
        }
        else { //fallback, in case "markfordeath" does not do the trick
            RagdollNPC(npc, "0");
            npc.Kill(GetPlayer(npc.GetGame()), false, false);
        }
    }
    else {
        if mode == 2 { //force ragdoll death
            RagdollNPC(npc, "0");
            npc.Kill(GetPlayer(npc.GetGame()), false, false);
        }
    }
    */
    SpawnBloodPuddle(npc);
    npc.KilledCleanlyCount = npc.KilledCleanlyCount + 1;
}


public func DefeatNPCCleanly(npc: ref<NPCPuppet>) {
    npc.SetMyKiller(GetPlayer(npc.GetGame()));
    npc.MarkForDefeat();
}

public func SpawnBloodPuddle(npc: ref<NPCPuppet>) {
    npc.m_shouldSpawnBloodPuddle = true;
    npc.m_bloodPuddleSpawned = false;
    let evt: ref<BloodPuddleEvent> = new BloodPuddleEvent();
    if !IsDefined(npc) || VehicleComponent.IsMountedToVehicle(npc.GetGame(), npc) {
      return;
    };
    evt = new BloodPuddleEvent();
    evt.m_slotName = n"Chest";
    evt.cyberBlood = NPCManager.HasVisualTag(npc, n"CyberTorso");
    GameInstance.GetDelaySystem(npc.GetGame()).DelayEvent(npc, evt, 0.10, false);

    let resetBloodPuddlePropertiesCallback: ref<DelayedResetBloodPuddlePropertiesCallback> = new DelayedResetBloodPuddlePropertiesCallback();
    resetBloodPuddlePropertiesCallback.entity = npc;
    GameInstance.GetDelaySystem(npc.GetGame()).DelayCallback(resetBloodPuddlePropertiesCallback, 0.20, false);
}

public func ResetBloodPuddleProperties(npc: ref<NPCPuppet>) {
  npc.m_shouldSpawnBloodPuddle = false;
  npc.m_bloodPuddleSpawned = false;
}

public func RagdollNPC(target: ref<NPCPuppet>, pushForce: String) {
    if IsDefined(target) {
        target.QueueEvent(CreateForceRagdollEvent(n"Debug Command"));
        if NotEquals(pushForce, "") {
            GameInstance.GetDelaySystem(target.GetGame()).DelayEvent(target, CreateRagdollApplyImpulseEvent(target.GetWorldPosition(), Vector4.Normalize(target.GetWorldPosition()) * 0.0, 0.00), 0.00, false);// Vector4.Normalize(target.GetWorldPosition()) * StringToFloat(pushForce), 5.00), 0.10, false);
        }
    }
}
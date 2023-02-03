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
    let isPowerAttack: Bool = Equals(RPGManager.GetWeaponEvolution(attackData.GetWeapon().GetItemID()), gamedataWeaponEvolution.Power);
    let isSmartAttack: Bool = Equals(RPGManager.GetWeaponEvolution(attackData.GetWeapon().GetItemID()), gamedataWeaponEvolution.Smart);
    let isTechAttack: Bool = Equals(RPGManager.GetWeaponEvolution(attackData.GetWeapon().GetItemID()), gamedataWeaponEvolution.Tech);
    let isSilencedAttack: Bool = ScriptedPuppet.GetActiveWeapon(player).IsSilenced();
    let CurrentAttackIsViableHeadshot: Bool = true;
    let CurrentAttackIsViableCripplingShot: Bool = true;

    /*
    AttackData:
        GetAttackType() -> enum gamedataAttackType
        {
            ChargedWhipAttack = 0,
            Direct = 1,
            Effect = 2,
            Explosion = 3,
            GuardBreak = 4,
            Hack = 5,
            Melee = 6,
            PressureWave = 7,
            QuickMelee = 8,
            Ranged = 9,
            Reflect = 10,
            StrongMelee = 11,
            Thrown = 12,
            WhipAttack = 13,
            Count = 14,
            Invalid = 15
        }
        GetWeapon() -> WeaponObject

    WeaponObject:
        IsHeavyWeapon() : Bool
        IsMelee() : Bool
        IsRanged() : Bool
        IsCyberwareWeapon(weaponID : gameItemID) : Bool
        IsFists(weaponID : gameItemID) : Bool
        IsMelee(weaponID : gameItemID) : Bool
        IsOneHandedRanged(weaponID : gameItemID) : Bool
        IsRanged(weaponID : gameItemID) : Bool
        IsOfType(weaponID : gameItemID, type : gamedataItemType) : Bool
        GetWeaponType(weaponID : gameItemID) -> enum gamedataItemType {
            ...
            Cyb_Launcher = 14,
            Cyb_MantisBlades = 15,
            Cyb_NanoWires = 16,
            Cyb_StrongArms
            ...
            Wea_AssaultRifle = 54,
            Wea_Axe = 55,
            Wea_Chainsword = 56,
            Wea_Fists = 57,
            Wea_Hammer = 58,
            Wea_Handgun = 59,
            Wea_HeavyMachineGun = 60,
            Wea_Katana = 61,
            Wea_Knife = 62,
            Wea_LightMachineGun = 63,
            Wea_LongBlade = 64,
            Wea_Machete = 65,
            Wea_Melee = 66,
            Wea_OneHandedClub = 67,
            Wea_PrecisionRifle = 68,
            Wea_Revolver = 69,
            Wea_Rifle = 70,
            Wea_ShortBlade = 71,
            Wea_Shotgun = 72,
            Wea_ShotgunDual = 73,
            Wea_SniperRifle = 74,
            Wea_SubmachineGun = 75,
            Wea_TwoHandedClub = 76,
            ...
        }

        GetCurrentDamageType() -> enum gamedataDamageType
        {
            Chemical = 0,
            Electric = 1,
            Physical = 2,
            Thermal = 3,
            Count = 4,
            Invalid = 5
        }

    NotEquals(RPGManager.GetWeaponEvolution(weapon.GetItemID()), gamedataWeaponEvolution.Tech)
    enum gamedataWeaponEvolution
    {
        Blade = 0,
        Blunt = 1,
        None = 2,
        Power = 3,
        Smart = 4,
        Tech = 5,
        Count = 6,
        Invalid = 7,
    }
    */

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

    if hitValue > 0 {
        let weaponFamily: gamedataItemType = WeaponObject.GetWeaponType(attackData.GetWeapon().GetItemID());

        switch (weaponFamily) {
            case gamedataItemType.Wea_AssaultRifle:
                hitValue = Cast<Int32>(PDO.AssaultRifleDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Axe:
                hitValue = Cast<Int32>(PDO.AxeDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Chainsword:
                hitValue = Cast<Int32>(PDO.ChainswordDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Fists:
                hitValue = Cast<Int32>(PDO.FistDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Hammer:
                hitValue = Cast<Int32>(PDO.HammerDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Handgun:
                hitValue = Cast<Int32>(PDO.HandgunDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_HeavyMachineGun:
                hitValue = Cast<Int32>(PDO.HeavyMachineGunDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Katana:
                hitValue = Cast<Int32>(PDO.KatanaDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Revolver:
                hitValue = Cast<Int32>(PDO.RevolverDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Rifle:
                hitValue = Cast<Int32>(PDO.RifleDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_ShortBlade:
                hitValue = Cast<Int32>(PDO.ShortBladeDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Shotgun:
                hitValue = Cast<Int32>(PDO.ShotgunDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_ShotgunDual:
                hitValue = Cast<Int32>(PDO.DualShotgunDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_SniperRifle:
                hitValue = Cast<Int32>(PDO.SniperRifleDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_SubmachineGun:
                hitValue = Cast<Int32>(PDO.SubmachineGunDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_TwoHandedClub:
                hitValue = Cast<Int32>(PDO.TwoHandedClubDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_PrecisionRifle:
                hitValue = Cast<Int32>(PDO.PrecisionRifleDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_OneHandedClub:
                hitValue = Cast<Int32>(PDO.OneHandedClubDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Melee:
                hitValue = Cast<Int32>(PDO.MeleeDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Machete:
                hitValue = Cast<Int32>(PDO.MacheteDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_LongBlade:
                hitValue = Cast<Int32>(PDO.LongBladeDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_LightMachineGun:
                hitValue = Cast<Int32>(PDO.LightMachineGunDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Wea_Knife:
                hitValue = Cast<Int32>(PDO.KnifeDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Cyb_Launcher:
                hitValue = Cast<Int32>(PDO.CybLauncherDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Cyb_MantisBlades:
                hitValue = Cast<Int32>(PDO.CybMantisBladesDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Cyb_NanoWires:
                hitValue = Cast<Int32>(PDO.CybNanoWiresDamageModifier * Cast<Float>(hitValue));
                break;
            case gamedataItemType.Cyb_StrongArms:
                hitValue = Cast<Int32>(PDO.CybStrongArmsDamageModifier * Cast<Float>(hitValue));
                break;
        }

        if isBladeAttack {
            hitValue = Cast<Int32>(PDO.BladeDamageModifier * Cast<Float>(hitValue));
        }
        else {
            if isBluntAttack {
                hitValue = Cast<Int32>(PDO.BluntDamageModifier * Cast<Float>(hitValue));
            }
            else {
                if isPowerAttack {
                    hitValue = Cast<Int32>(PDO.PowerDamageModifier * Cast<Float>(hitValue));
                }
                else {
                    if isSmartAttack {
                        hitValue = Cast<Int32>(PDO.SmartDamageModifier * Cast<Float>(hitValue));
                    }
                    else {
                        if isTechAttack {
                            hitValue = Cast<Int32>(PDO.TechDamageModifier * Cast<Float>(hitValue));
                        }
                    }
                }
            }
        }
    }

    let CritChanceRand: Int32 = RandRange(0, 100);
    let InvCritChanceRand: Int32 = RandRange(0, 100);
    if (CritChanceRand < PDO.CritChance) {
        hitValue = hitValue * 2;
    }
    if (InvCritChanceRand < PDO.InvCritChance) {
        hitValue = hitValue / 2;
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
            KillNPCCleanlyModal(npc, 1);          
        }
    }
    else {
        if npc.torsohitcounter >= PDO.GetDSTorsoshotKillThreshold() && GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold()) {
            if !DetermineIfNPCIsBossOrPsycho(npc) {
                KillNPCCleanlyModal(npc, 1);          
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
                            KillNPCCleanlyModal(npc, 1);
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
                        KillNPCCleanlyModal(npc, 1);
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
    let isBluntAttack: Bool = Equals(RPGManager.GetWeaponEvolution(attackData.GetWeapon().GetItemID()), gamedataWeaponEvolution.Blunt);
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
    
    if dismFound && !isBluntAttack {
        DismembermentComponent.RequestDismemberment(npc, dismemberedBodypart, woundType, Vector4.EmptyVector());//this.m_hitShapeData.result.hitPositionEnter);
        npc.WasPDODismembered = true;
    }
}

public func KillNPCCleanlyModal(npc: ref<NPCPuppet>, mode: Int32) {
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
    /*
    RagdollNPC(npc, "0");
    GameInstance.GetStatPoolsSystem(GetGameInstance()).RequestSettingStatPoolMinValue(Cast<StatsObjectID>(npc.GetEntityID()), gamedataStatPoolType.Health, GetPlayer(npc.GetGame()));*/
    let DelayedKill: ref<DelayedKillCallback> = new DelayedKillCallback();
    DelayedKill.npc = npc;
    DelayedKill.killexecutedcounter = 1;
    GameInstance.GetDelaySystem(npc.GetGame()).DelayCallback(DelayedKill, 0.10, false);
    /*
    npc.SetMyKiller(GetPlayer(npc.GetGame()));
    RagdollNPC(npc, "0");
    SetNPCHealthInPercent(npc, 0);
    StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.InvulnerableAfterDefeated");
    StatusEffectHelper.RemoveStatusEffect(npc, t"BaseStatusEffect.Invulnerable");
    npc.toBeIncapacitated = false;
    npc.wasKilled = true;
    npc.MarkForDeath();
    npc.SetIsDefeatMechanicActive(false);
    npc.Kill(GetPlayer(npc.GetGame()), true, false);

    let DelayedKill: ref<DelayedKillCallback> = new DelayedKillCallback();
    DelayedKill.npc = npc;
    DelayedKill.counter = Cast<Int32>(1.0);
    GameInstance.GetDelaySystem(npc.GetGame()).DelayCallback(DelayedKill, 0.20, false);*/
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
    SetNPCHealthInPercent(npc, 0);
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

public class DelayedKillCallback extends DelayCallback {
    public let npc: ref<NPCPuppet>;
    public let killexecutedcounter: Int32;

    public func Call() -> Void {
        let DelayedKill: ref<DelayedKillCallback> = new DelayedKillCallback();
        DelayedKill.npc = this.npc;

        if GameInstance.GetStatsSystem(this.npc.GetGame()).GetStatValue(Cast<StatsObjectID>(this.npc.GetEntityID()), gamedataStatType.IsInvulnerable) > 0.00 {
            RagdollNPC(this.npc, "0");
            StatusEffectHelper.RemoveStatusEffect(this.npc, t"BaseStatusEffect.InvulnerableAfterDefeated");
            StatusEffectHelper.RemoveStatusEffect(this.npc, t"BaseStatusEffect.Invulnerable");
            GameInstance.GetDelaySystem(this.npc.GetGame()).DelayCallback(DelayedKill, 10.00, false);
        }
        else {
            if this.killexecutedcounter > 10 {
                let hitev: ref<gameHitEvent> = this.npc.m_lastHitEvent;
                StatPoolsManager.DrainStatPool(hitev, gamedataStatPoolType.Health, 10.0);
            }
            else {
                RagdollNPC(this.npc, "0");
                //this.npc.Kill(GetPlayer(this.npc.GetGame()), true, false);
                //this.npc.SetMyKiller(GetPlayer(this.npc.GetGame()));
                //RagdollNPC(this.npc, "0");
                //SetNPCHealthInPercent(this.npc, 0);
                //this.npc.toBeIncapacitated = false;
                //this.npc.MarkForDeath();
                //this.npc.SetIsDefeatMechanicActive(false);
                this.npc.Kill(GetPlayer(this.npc.GetGame()), true, false);
                DelayedKill.killexecutedcounter = this.killexecutedcounter + 1;
                GameInstance.GetDelaySystem(this.npc.GetGame()).DelayCallback(DelayedKill, 0.50, false);
            }
        }
    }
}

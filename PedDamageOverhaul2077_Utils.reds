module PDOUtils

public static final func IsPlayerLookingAtNPC(npc: ref<NPCPuppet>) -> Bool{
    if IsDefined(npc) {
        let player: wref<PlayerPuppet> = GetPlayer(npc.GetGame());
        let targetingSystem: ref<TargetingSystem> = GameInstance.GetTargetingSystem(npc.GetGame());
        let targetObject: ref<GameObject> = targetingSystem.GetLookAtObject(player, false, false);
        if targetObject.IsNPC() && IsDefined(targetObject) {
            let target: ref<NPCPuppet> = targetObject as NPCPuppet;
            let distance = Vector4.Distance(player.GetWorldPosition(), targetObject.GetWorldPosition());
            if Equals(npc.GetEntityID(), target.GetEntityID()) {
                if distance <= 15.0 {
                    return true;
                }
            }
        }
    }
    return false;
}

public func ShouldNPCBeExcluded(npc: ref<NPCPuppet>) -> Bool {
    let excludedNPCs: array<String>;
    ArrayPush(excludedNPCs, "citizen__lowlife_ma__mq025__twin_01"); //quest: beat the brat
    ArrayPush(excludedNPCs, "citizen__lowlife_ma__mq025__twin_02"); //quest: beat the brat
    ArrayPush(excludedNPCs, "gang__6tstreet_mb__mq025__buck"); //quest: beat the brat
    ArrayPush(excludedNPCs, "gang__6thstreet_ma__mq025__buck"); //quest: beat the brat
    ArrayPush(excludedNPCs, "gang__valentinos_ma__mq025__el_cesar"); //quest: beat the brat
    ArrayPush(excludedNPCs, "gang__animals_wba__mq025__rhino"); //quest: beat the brat
    ArrayPush(excludedNPCs, "ozob_default"); //quest: beat the brat
    ArrayPush(excludedNPCs, "ozob_no_jacket"); //quest: beat the brat
    ArrayPush(excludedNPCs, "gang__animals_mba__mq025__razor_hugh"); //quest: beat the brat

    let NPCFound: Bool;
    NPCFound = false;

    let appearance: CName = npc.GetCurrentAppearanceName();

    let i = 0;
    while i < ArraySize(excludedNPCs) && !NPCFound {
        if StrFindFirst(ToString(appearance), excludedNPCs[i]) != -1 {
            npc.gender = 10;
            NPCFound = true;
            return NPCFound;
        }
        i += 1;
    }
    return NPCFound;
}

/*
if IsDefined(ownerPuppet) && IsDefined(ownerPuppet.GetPuppetStateBlackboard()) {
      ownerPuppet.GetPuppetStateBlackboard().SetInt(GetAllBlackboardDefs().PuppetState.ReactionBehavior, EnumInt(gamedataOutput.Ignore));
*/

public func MakeNPCFlee(npc: ref<NPCPuppet>) {
    let player: wref<PlayerPuppet> = GetPlayer(npc.GetGame());
    GameInstance.GetReactionSystem(npc.GetGame()).RegisterFearReaction(npc, player);
    /*let reactionManager: ref<ReactionManagerComponent> = npc.m_reactionComponent;
    
    let stimData: ref<StimEventTaskData>;
    stimData = 

    let stimEvent: ref<StimuliEvent>;
    let stimParams: StimParams;
    stimEvent = stimData.cachedEvt;
    stimParams = reactionManager.ProcessStimParams(stimEvent);

    reactionManager.TriggerBehaviorReaction(stimParams.reactionOutput, stimData, stimParams.stimData);
    */
}


public func DoDamageEffectCalculations(npc: ref<NPCPuppet>, hitUserData: ref<HitShapeUserDataBase>, hitShapeTypeString: String, hitEvent: ref<gameHitEvent>) {
    //let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(GetGameInstance());
    let player: wref<PlayerPuppet> = GetPlayer(npc.GetGame());
    let hitValue: Int32;
    let PDO: ref<PedDamageOverhaul2077> = PedDamageOverhaul2077.GetInstance();
    let attackData: ref<AttackData> = hitEvent.attackData;
    let isBluntAttack: Bool = Equals(RPGManager.GetWeaponEvolution(attackData.GetWeapon().GetItemID()), gamedataWeaponEvolution.Blunt);
    let isSilencedAttack: Bool = ScriptedPuppet.GetActiveWeapon(player).IsSilenced();


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
        if !((isBluntAttack && !PDO.HeadShotsWithBluntWeapons) && GetNPCHealthInPercent(npc) > Cast<Float>(PDO.GetDyingStateThreshold()) && (isSilencedAttack && !PDO.HeadShotsWithSilencedWeapons)) {
            npc.headhitcounter = npc.headhitcounter + hitValue;
        }
    }
    else {
        if HitShapeUserDataBase.IsHitReactionZoneTorso(hitUserData) {
            if !(isBluntAttack && !PDO.HeadShotsWithBluntWeapons && GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold())) {
                npc.torsohitcounter = npc.torsohitcounter + hitValue;
            }
        }
        else {
            if HitShapeUserDataBase.IsHitReactionZoneLeftArm(hitUserData) {
              if !(isBluntAttack && !PDO.CripplingWithBluntWeapons) && PDO.CripplingArms {
                npc.leftarmhitcounter = npc.leftarmhitcounter + hitValue;
              }
            }
            else {
                if HitShapeUserDataBase.IsHitReactionZoneRightArm(hitUserData) {
                    if !(isBluntAttack && !PDO.CripplingWithBluntWeapons) && PDO.CripplingArms {
                        npc.rightarmhitcounter = npc.rightarmhitcounter + hitValue;
                    }
                }
                else {
                    if HitShapeUserDataBase.IsHitReactionZoneRightLeg(hitUserData) {
                        if !(isBluntAttack && !PDO.CripplingWithBluntWeapons) {
                            npc.rightleghitcounter = npc.rightleghitcounter + hitValue;
                        }
                    }
                    else {
                        if HitShapeUserDataBase.IsHitReactionZoneLeftLeg(hitUserData) {
                            if !(isBluntAttack && !PDO.CripplingWithBluntWeapons) {
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
    if npc.leftarmhitcounter >= PDO.GetArmDamagedThreshold() {
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledArmLeft") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledHandLeft") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledArmLeft", 0.10);
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledHandLeft", 0.10);
        }
    }
    if npc.rightarmhitcounter >= PDO.GetArmDamagedThreshold() {
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledArmRight") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledHandRight") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledArmRight", 0.10);
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledHandRight", 0.10);
        }
    }
    if npc.leftleghitcounter >= PDO.GetLegDamagedThreshold() {
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledLegLeft") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledLegLeft", 0.10);
        }
    }
    if npc.rightleghitcounter >= PDO.GetLegDamagedThreshold() {
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.CrippledLegRight") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.CrippledLegRight", 0.10);
        }
    }
    if npc.torsohitcounter >= PDO.GetTorsoDamagedThreshold() {
        if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Crippled") || !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.Wounded") {
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Crippled", 0.10);
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.Wounded", 0.10);
        }
    }
    if npc.headhitcounter >= PDO.GetHeadshotKillThreshold() && PDO.GetHeadshotsKill() {
        if !DetermineIfNPCIsBoss(npc) {
            if !npc.hasBeenAffectedByMod {
                npc.MarkForDefeat();
            }
            else {
                KillNPCCleanly(npc);
            }          
        }
    }
    if npc.torsohitcounter >= PDO.GetTorsoshotKillThreshold() && PDO.GetHeadshotsKill() {
        if !DetermineIfNPCIsBoss(npc) {
            if GetNPCHealthInPercent(npc) < Cast<Float>(PDO.GetDyingStateThreshold()) {
                KillNPCCleanly(npc);
            }
            else {
                npc.MarkForDefeat();
            }          
        }
    }
    if (npc.rightleghitcounter >= PDO.GetLegDamagedThreshold() && npc.leftleghitcounter >= PDO.GetLegDamagedThreshold()) || (npc.rightarmhitcounter >= PDO.GetArmDamagedThreshold() && npc.leftarmhitcounter >= PDO.GetArmDamagedThreshold()) {
        if PDO.CripplingPutsNPCsDown {
            SetNPCHealthInPercent(npc, Cast<Float>(PDO.DyingStateThreshold));
            npc.DyingStateForced = true;
        }
    }
}

public func KillNPCCleanly(npc: ref<NPCPuppet>) {
    //let player: ref<PlayerPuppet> = GetPlayer(npc.GetGame());
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
    if npc.KilledCleanlyCount == 0 {
        npc.MarkForDeath();
    }
    else {
        let player: wref<PlayerPuppet> = GetPlayer(npc.GetGame());
        RagdollNPC(npc, "0");
        npc.Kill(player, false, false);
    }    
    SpawnBloodPuddle(npc);
    npc.KilledCleanlyCount = npc.KilledCleanlyCount + 1;
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

public func RagdollNPC(target: ref<NPCPuppet>, pushForce: String) {
    if IsDefined(target) {
        target.QueueEvent(CreateForceRagdollEvent(n"Debug Command"));
        if NotEquals(pushForce, "") {
            GameInstance.GetDelaySystem(target.GetGame()).DelayEvent(target, CreateRagdollApplyImpulseEvent(target.GetWorldPosition(), Vector4.Normalize(target.GetWorldPosition()) * 0.0, 0.00), 0.00, false);// Vector4.Normalize(target.GetWorldPosition()) * StringToFloat(pushForce), 5.00), 0.10, false);
        }
    }
}

public func PlaySound(npc: ref<NPCPuppet>, audio: CName) {
    if Equals(npc.GetNPCType(), gamedataNPCType.Human) {
        let soundEvent = new SoundPlayEvent();
        soundEvent.soundName = audio;
        npc.lastpainaudio = audio;
        npc.QueueEvent(soundEvent);
    }
}

public func PlayVoiceOver(npc: ref<NPCPuppet>, audio: CName) {
    let evt = new SoundPlayVo();
    evt.voContext = audio;
    npc.QueueEvent(evt);
    npc.lastpainvoiceover = audio;
}

public func GetMoanAudio(lastmoanaudio: CName, npc: ref<NPCPuppet>) -> CName{
    let randomnr: Int32;
    let audio: array<CName>;
    let returnvalue: CName;
    if npc.gender != 10 && npc.gender != 20 {
        DetermineNPCGender(npc);
    }
	if npc.gender == 10 {
        ArrayPush(audio, n"ono_takemura_pain_short");
        ArrayPush(audio, n"ono_generic_m_pain_long_set_05");
        ArrayPush(audio, n"ono_generic_m_pain_short_set_05");
        ArrayPush(audio, n"ono_animals_m_pain_long_set_04");
    }
    else {
        ArrayPush(audio, n"ono_regina_pain_long");
        ArrayPush(audio, n"ono_animals_f_pain_long_set_01");
        ArrayPush(audio, n"ono_generic_f_pain_long_set_01");
        ArrayPush(audio, n"ono_animals_f_pain_short_set");
        ArrayPush(audio, n"ono_animals_f_pain_short_set_01");
        ArrayPush(audio, n"ono_generic_f_pain_short_set_01");
    }
    returnvalue = lastmoanaudio;
    while Equals(returnvalue, lastmoanaudio) {
        randomnr = RandRange(0, ArraySize(audio));
        returnvalue = audio[randomnr];
    }
    return returnvalue;    
}

public func LogStatusEffects(playerPuppet: ref<gamePuppetBase>) -> Void {
  let appliedEffects: array<ref<StatusEffect>>;
  if playerPuppet != null {
    GameInstance.GetStatusEffectSystem(playerPuppet.GetGame()).GetAppliedEffects(playerPuppet.GetEntityID(), appliedEffects);
    LogChannel(n"DEBUG", "List of Status Effects for NPC " + ToString(playerPuppet.GetEntityID()));
    let i: Int32 = 0;
    while i < ArraySize(appliedEffects) {
      let record: ref<StatusEffect_Record>;
      record = appliedEffects[i].GetRecord();
      LogChannel(n"DEBUG", "Status effect " + ToString(i) + ": " + TDBID.ToStringDEBUG(record.GetID()) + ", " + record.UiData().DisplayName() + ", d=" + appliedEffects[i].GetRemainingDuration());
      i += 1;
    }
  }
}

public func GetFireAudio(lastfireaudio: CName, npc: ref<NPCPuppet>) -> CName{
    let randomnr: Int32;
    let audio: array<CName>;
    let returnvalue: CName;
    if npc.gender != 10 && npc.gender != 20 {
        DetermineNPCGender(npc);
    }
	if npc.gender == 10 {
        ArrayPush(audio, n"ono_jackie_fear_panic_scream");
        ArrayPush(audio, n"ono_sobchak_fear_panic_scream");
        ArrayPush(audio, n"ono_generic_m_fear_scream_set_04");
        ArrayPush(audio, n"ono_animals_m_fear_scream_set_04");
    }
    else {
        ArrayPush(audio, n"ono_hanako_fear_panic_scream");
        ArrayPush(audio, n"ono_panam_fear_panic_scream");
        ArrayPush(audio, n"ono_regina_fear_panic_scream");
    }
    returnvalue = lastfireaudio;
    while Equals(returnvalue, lastfireaudio) {
        randomnr = RandRange(0, ArraySize(audio));
        returnvalue = audio[randomnr];
    }
    return returnvalue;    
}

public func GetPainAudio(lastpainaudio: CName, npc: ref<NPCPuppet>) -> CName{
    let randomnr: Int32;
    let audio: array<CName>;
    let returnvalue: CName;
    if npc.gender != 10 && npc.gender != 20 {
        DetermineNPCGender(npc);
    }
	if npc.gender == 10 {
        ArrayPush(audio, n"ono_generic_m_pain_long_set_01");
        ArrayPush(audio, n"ono_generic_m_pain_long_set_02");
        ArrayPush(audio, n"ono_generic_m_pain_long_set_03");
        ArrayPush(audio, n"ono_generic_m_pain_long_set_04");
        ArrayPush(audio, n"ono_generic_m_pain_long_set_05");
        ArrayPush(audio, n"ono_generic_m_fear_scream_set_01");
        ArrayPush(audio, n"ono_generic_m_fear_scream_set_02");
        ArrayPush(audio, n"ono_generic_m_fear_scream_set_03");
        ArrayPush(audio, n"ono_generic_m_fear_scream_set_04");
        ArrayPush(audio, n"ono_generic_m_fear_scream_set_05");
    }
    else {
        ArrayPush(audio, n"ono_generic_f_pain_long_set_01");
        ArrayPush(audio, n"ono_generic_f_pain_long_set_02");
        ArrayPush(audio, n"ono_generic_f_pain_long_set_03");
        ArrayPush(audio, n"ono_generic_f_pain_long_set_04");
        ArrayPush(audio, n"ono_generic_f_fear_scream_set_01");
        ArrayPush(audio, n"ono_generic_f_fear_scream_set_02");
        ArrayPush(audio, n"ono_generic_f_fear_scream_set_03");
        ArrayPush(audio, n"ono_generic_f_fear_scream_set_04");            
    }
    returnvalue = lastpainaudio;
    while Equals(returnvalue, lastpainaudio) {
        randomnr = RandRange(0, ArraySize(audio));
        returnvalue = audio[randomnr];
    }
    return returnvalue;    
}

public func GetNPCHealth(target: ref<NPCPuppet>) -> Float {
    if IsDefined(target) {
        let npcID: StatsObjectID = Cast(target.GetEntityID());
        return GameInstance.GetStatPoolsSystem(target.GetGame()).GetStatPoolValue(npcID, gamedataStatPoolType.Health, false);
    }
    else {
        return -1.0;
    }
}

public func GetNPCHealthInPercent(target: ref<NPCPuppet>) -> Float {
    if IsDefined(target) {
        let npcID: StatsObjectID = Cast(target.GetEntityID());
        return GameInstance.GetStatPoolsSystem(target.GetGame()).GetStatPoolValue(npcID, gamedataStatPoolType.Health, true);
    }
    else {
        return -1.0;
    }
}

public func SetNPCHealthInPercent(target: ref<NPCPuppet>, health: Float) -> Void {
    if IsDefined(target) {
        let npcID: StatsObjectID = Cast(target.GetEntityID());
        GameInstance.GetStatPoolsSystem(target.GetGame()).RequestSettingStatPoolValue(npcID, gamedataStatPoolType.Health, health, null, true);
    }
}

public func AddNPCHealth(target: ref<NPCPuppet>, health: Float) -> Void {
    if IsDefined(target) {
        let npcID: StatsObjectID = Cast(target.GetEntityID());
        GameInstance.GetStatPoolsSystem(target.GetGame()).RequestChangingStatPoolValue(npcID, gamedataStatPoolType.Health, health, null, true, true);
    }
}

public func DetermineIfNPCIsBoss(npc: ref<NPCPuppet>) -> Bool {
    let appearance: CName = npc.GetCurrentAppearanceName();

    if StrFindFirst(ToString(appearance), "boss") != -1 {
            npc.isBoss = true;
            return true;
    }
    else {
        if StrFindFirst(ToString(appearance), "psycho") != -1 {
            npc.isBoss = true;
            return true;
        }
        else {
            npc.isBoss = false;
            return false;
        }
    }
}

public func DetermineNPCGender(npc: ref<NPCPuppet>) -> Bool {
    let genderstringsmale: array<String>;
    ArrayPush(genderstringsmale, "_ma");
    ArrayPush(genderstringsmale, "ma_");
    ArrayPush(genderstringsmale, "_ma_");
    ArrayPush(genderstringsmale, "_mb");
    ArrayPush(genderstringsmale, "mb_");
    ArrayPush(genderstringsmale, "_mb_");
    ArrayPush(genderstringsmale, "_mf");
    ArrayPush(genderstringsmale, "mf_");
    ArrayPush(genderstringsmale, "_mf_");
    ArrayPush(genderstringsmale, "_maf");
    ArrayPush(genderstringsmale, "maf_");
    ArrayPush(genderstringsmale, "_maf_");
    ArrayPush(genderstringsmale, "_mbf");
    ArrayPush(genderstringsmale, "mbf_");
    ArrayPush(genderstringsmale, "_mbf_");
    ArrayPush(genderstringsmale, "_mba");
    ArrayPush(genderstringsmale, "mba_");
    ArrayPush(genderstringsmale, "_mba_");
    ArrayPush(genderstringsmale, "_mm");
    ArrayPush(genderstringsmale, "mm_");
    ArrayPush(genderstringsmale, "_mm_");
    ArrayPush(genderstringsmale, "_ms");
    ArrayPush(genderstringsmale, "ms_");
    ArrayPush(genderstringsmale, "_ms_");
    ArrayPush(genderstringsmale, "_mc");
    ArrayPush(genderstringsmale, "mc_");
    ArrayPush(genderstringsmale, "_mc_");

    let genderstringsfemale: array<String>;    
    ArrayPush(genderstringsfemale, "_wa");
    ArrayPush(genderstringsfemale, "wa_");
    ArrayPush(genderstringsfemale, "_wa_");
    ArrayPush(genderstringsfemale, "_wb");
    ArrayPush(genderstringsfemale, "wb_");
    ArrayPush(genderstringsfemale, "_wb_");
    ArrayPush(genderstringsfemale, "_wf");
    ArrayPush(genderstringsfemale, "wf_");
    ArrayPush(genderstringsfemale, "_wf_");
    ArrayPush(genderstringsfemale, "_waf");
    ArrayPush(genderstringsfemale, "waf_");
    ArrayPush(genderstringsfemale, "_waf_");
    ArrayPush(genderstringsfemale, "_wbf");
    ArrayPush(genderstringsfemale, "wbf_");
    ArrayPush(genderstringsfemale, "_wbf_");
    ArrayPush(genderstringsfemale, "_wba");
    ArrayPush(genderstringsfemale, "wba_");
    ArrayPush(genderstringsfemale, "_wba_");
    ArrayPush(genderstringsfemale, "_wm");
    ArrayPush(genderstringsfemale, "wm_");
    ArrayPush(genderstringsfemale, "_wm_");
    ArrayPush(genderstringsfemale, "_ws");
    ArrayPush(genderstringsfemale, "ws_");
    ArrayPush(genderstringsfemale, "_ws_");
    ArrayPush(genderstringsfemale, "_wc");
    ArrayPush(genderstringsfemale, "wc_");
    ArrayPush(genderstringsfemale, "_wc_");

    let genderfound: Bool;
    genderfound = false;

    let appearance: CName = npc.GetCurrentAppearanceName();

    //Exceptions
    if Equals(ToString(appearance), "scavenger_boss_Sh0410_shootingav_01__cybergore") {
        npc.gender = 10;
        genderfound = true;
        return genderfound;
    }

    if Equals(ToString(appearance), "special__cyberpsycho_wa_ma_wat_kab_08_major") {
        npc.gender = 20;
        genderfound = true;
        return genderfound;
    }

    //Standard
    let i = 0;
    while i < ArraySize(genderstringsmale) && !genderfound {
        if StrFindFirst(ToString(appearance), genderstringsmale[i]) != -1 {
            npc.gender = 10;
            genderfound = true;
            return genderfound;
        }
        i += 1;
    }

    i = 0;
    while i < ArraySize(genderstringsfemale) && !genderfound {
        if StrFindFirst(ToString(appearance), genderstringsfemale[i]) != -1 {
            npc.gender = 20;
            genderfound = true;
            return genderfound;
        }
        i += 1;
    }

    return false;
}
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
    ArrayPush(excludedNPCs, "special__training_dummy_ma_dummy_boxing"); //quest: beat the brat
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
public func MakeNPCFlee(npc: ref<NPCPuppet>) {
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(GetGameInstance());
    if !statusEffectSystem.HasStatusEffect(npc.GetEntityID(), t"BaseStatusEffect.UncontrolledMovement_Default"){
          StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.UncontrolledMovement_Default", 0.10);
    }
*/
/*
    player.GetStimBroadcasterComponent().TriggerSingleBroadcast(player, gamedataStimType.Terror, 3.00);
      /*
      let FearEvent = new StimuliEvent();
      FearEvent.SetStimType(gamedataStimType.Terror);
      FearEvent.name = n"run";
      npc.QueueEvent(FearEvent);
      */
      //NPCPuppet.ChangeHighLevelState(npc, gamedataNPCHighLevelState.Fear);
      //NPCPuppet.ChangeHighLevelState(npc, gamedataNPCHighLevelState.Fear);
      //AnimationControllerComponent.SetAnimWrapperWeightOnOwnerAndItems(npc, n"fear", 1.00);
      /*
        return n"disturbed";
        };
        return n"default";
      case 2:
        return n"fear";
      case 3:
        return n"panic";
      default:
        return n"default";
      */
      //AnimationControllerComponent.SetAnimWrapperWeightOnOwnerAndItems(npc, n"FearLocomotion1", 1.00);
      /*
       let rand: Float;
    if Equals(stimType, gamedataStimType.Driving) {
      rand = RandF();
      if rand <= 0.33 {
        return n"FearLocomotion1";
      };
      if rand > 0.33 && rand <= 0.66 {
        return n"FearLocomotion3";
      };
      return n"FearLocomotion4";
    };
    rand = RandF();
    if rand > 0.25 && rand <= 0.50 {
      return n"FearLocomotion1";
    };
    if rand > 0.50 && rand <= 0.75 {
      return n"FearLocomotion2";
    };
    if rand <= 0.25 {
      return n"FearLocomotion3";
    };
    return n"FearLocomotion4";
      */

      -----
    
    let player: wref<PlayerPuppet> = GetPlayer(npc.GetGame());
    GameInstance.GetReactionSystem(npc.GetGame()).RegisterFearReaction(npc, player);
    if IsDefined(npc) && IsDefined(npc.GetPuppetStateBlackboard()) {
      npc.GetPuppetStateBlackboard().SetInt(GetAllBlackboardDefs().PuppetState.ReactionBehavior, EnumInt(gamedataOutput.Flee));
    }
*/
    /*
if IsDefined(ownerPuppet) && IsDefined(ownerPuppet.GetPuppetStateBlackboard()) {
      ownerPuppet.GetPuppetStateBlackboard().SetInt(GetAllBlackboardDefs().PuppetState.ReactionBehavior, EnumInt(gamedataOutput.Ignore));
*/
    /*let reactionManager: ref<ReactionManagerComponent> = npc.m_reactionComponent;
    
    let stimData: ref<StimEventTaskData>;
    stimData = 

    let stimEvent: ref<StimuliEvent>;
    let stimParams: StimParams;
    stimEvent = stimData.cachedEvt;
    stimParams = reactionManager.ProcessStimParams(stimEvent);

    reactionManager.TriggerBehaviorReaction(stimParams.reactionOutput, stimData, stimParams.stimData);
    */
//}

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

public func DetermineIfNPCIsBossOrPsycho(npc: ref<NPCPuppet>) -> Bool {
    if npc.IsBoss() {
        npc.isBoss = true;
        return true;
    }
    else
    {
        let appearance: CName = npc.GetCurrentAppearanceName();
        let appearances: array<String>;
        ArrayPush(appearances, "gang__maelstrom_mb__q003__brick");
        ArrayPush(appearances, "oda_oda");
        ArrayPush(appearances, "woodman");
        ArrayPush(appearances, "royce");
        ArrayPush(appearances, "akira");
        ArrayPush(appearances, "placide");
        ArrayPush(appearances, "anton_kolev");
        ArrayPush(appearances, "barry_alken");
        ArrayPush(appearances, "bruce_ward");
        ArrayPush(appearances, "denzel_cryer");
        ArrayPush(appearances, "kaiser_herzog");
        ArrayPush(appearances, "miguel_rodrigez");
        ArrayPush(appearances, "mokomichi_yamada");
        ArrayPush(appearances, "olga_elisabeth_longmead");
        ArrayPush(appearances, "paul_craven");
        ArrayPush(appearances, "rufus_mcbride");
        ArrayPush(appearances, "shibobu_imai");
        ArrayPush(appearances, "stanislaus_zbyszko");
        ArrayPush(appearances, "tom_ymir_ayer");
        ArrayPush(appearances, "yelena_sidorova");
        ArrayPush(appearances, "zie_alonzo");
        ArrayPush(appearances, "dante_m");
        ArrayPush(appearances, "dante_n");
        ArrayPush(appearances, "reed");
        ArrayPush(appearances, "jeremiah_grayson");
        ArrayPush(appearances, "kurt_bossfight");
    
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
                let i = 0;
                while i < ArraySize(appearances) {
                    if StrFindFirst(ToString(appearance), appearances[i]) != -1 {
                        npc.isBoss = true;
                        return true;
                    }
                    i += 1;
                }
                npc.isBoss = false;
                return false;
            }
        }
    }
}

public func DetermineNPCGender(npc: ref<NPCPuppet>) -> Bool {
    let genderstringsmale1: array<String>;
    let genderstringsmale2: array<String>;
    ArrayPush(genderstringsmale2, "_ma");
    ArrayPush(genderstringsmale2, "ma_");
    ArrayPush(genderstringsmale1, "_ma_");
    ArrayPush(genderstringsmale2, "_mb");
    ArrayPush(genderstringsmale2, "mb_");
    ArrayPush(genderstringsmale1, "_mb_");
    ArrayPush(genderstringsmale2, "_mf");
    ArrayPush(genderstringsmale2, "mf_");
    ArrayPush(genderstringsmale1, "_mf_");
    ArrayPush(genderstringsmale2, "_maf");
    ArrayPush(genderstringsmale2, "maf_");
    ArrayPush(genderstringsmale1, "_maf_");
    ArrayPush(genderstringsmale2, "_mbf");
    ArrayPush(genderstringsmale2, "mbf_");
    ArrayPush(genderstringsmale1, "_mbf_");
    ArrayPush(genderstringsmale2, "_mba");
    ArrayPush(genderstringsmale2, "mba_");
    ArrayPush(genderstringsmale1, "_mba_");
    ArrayPush(genderstringsmale2, "_mm");
    ArrayPush(genderstringsmale2, "mm_");
    ArrayPush(genderstringsmale1, "_mm_");
    ArrayPush(genderstringsmale2, "_ms");
    ArrayPush(genderstringsmale2, "ms_");
    ArrayPush(genderstringsmale1, "_ms_");
    ArrayPush(genderstringsmale2, "_mc");
    ArrayPush(genderstringsmale2, "mc_");
    ArrayPush(genderstringsmale1, "_mc_");

    let genderstringsfemale1: array<String>;
    let genderstringsfemale2: array<String>;    
    ArrayPush(genderstringsfemale2, "_wa");
    ArrayPush(genderstringsfemale2, "wa_");
    ArrayPush(genderstringsfemale1, "_wa_");
    ArrayPush(genderstringsfemale2, "_wb");
    ArrayPush(genderstringsfemale2, "wb_");
    ArrayPush(genderstringsfemale1, "_wb_");
    ArrayPush(genderstringsfemale2, "_wf");
    ArrayPush(genderstringsfemale2, "wf_");
    ArrayPush(genderstringsfemale1, "_wf_");
    ArrayPush(genderstringsfemale2, "_waf");
    ArrayPush(genderstringsfemale2, "waf_");
    ArrayPush(genderstringsfemale1, "_waf_");
    ArrayPush(genderstringsfemale2, "_wbf");
    ArrayPush(genderstringsfemale2, "wbf_");
    ArrayPush(genderstringsfemale1, "_wbf_");
    ArrayPush(genderstringsfemale2, "_wba");
    ArrayPush(genderstringsfemale2, "wba_");
    ArrayPush(genderstringsfemale1, "_wba_");
    ArrayPush(genderstringsfemale2, "_wm");
    ArrayPush(genderstringsfemale2, "wm_");
    ArrayPush(genderstringsfemale1, "_wm_");
    ArrayPush(genderstringsfemale2, "_ws");
    ArrayPush(genderstringsfemale2, "ws_");
    ArrayPush(genderstringsfemale1, "_ws_");
    ArrayPush(genderstringsfemale2, "_wc");
    ArrayPush(genderstringsfemale2, "wc_");
    ArrayPush(genderstringsfemale1, "_wc_");

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
    while i < ArraySize(genderstringsmale1) && !genderfound {
        if StrFindFirst(ToString(appearance), genderstringsmale1[i]) != -1 {
            npc.gender = 10;
            genderfound = true;
            return genderfound;
        }
        i += 1;
    }

    i = 0;
    while i < ArraySize(genderstringsfemale1) && !genderfound {
        if StrFindFirst(ToString(appearance), genderstringsfemale1[i]) != -1 {
            npc.gender = 20;
            genderfound = true;
            return genderfound;
        }
        i += 1;
    }

    i = 0;
    while i < ArraySize(genderstringsmale2) && !genderfound {
        if StrFindFirst(ToString(appearance), genderstringsmale2[i]) != -1 {
            npc.gender = 10;
            genderfound = true;
            return genderfound;
        }
        i += 1;
    }

    i = 0;
    while i < ArraySize(genderstringsfemale2) && !genderfound {
        if StrFindFirst(ToString(appearance), genderstringsfemale2[i]) != -1 {
            npc.gender = 20;
            genderfound = true;
            return genderfound;
        }
        i += 1;
    }

    return false;
}
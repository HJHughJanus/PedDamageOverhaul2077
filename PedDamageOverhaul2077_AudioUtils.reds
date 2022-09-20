module PDOAudioUtils

import PDOUtils.*

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
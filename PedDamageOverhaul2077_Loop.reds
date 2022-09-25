module PDOLoop

import PDO.*
import PDOUtils.*
import PDODamageUtils.*
import PDOAudioUtils.*


public func MainLoop(npc: ref<NPCPuppet>) {

  let mainLoopCallback: ref<DelayedMainLoopCallback> = new DelayedMainLoopCallback();
  mainLoopCallback.entity = npc;
  if IsDefined(npc) && !npc.IsDead(){
  
    let PDO: ref<PedDamageOverhaul2077> = PedDamageOverhaul2077.GetInstance();
    npc.hasBeenAffectedByMod = true;
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
        npc.fireaudiointerval = 39;
        if PDO.PlayPainSounds {
          PlaySound(npc, GetFireAudio(npc.lastfireaudio, npc));
        }
      }
      else {
        npc.timeonfire = npc.timeonfire + Cast<Uint32>(1);
        if (npc.lasttimefireaudio + Cast<Uint32>(npc.fireaudiointerval)) < npc.timeonfire {
          npc.lasttimefireaudio = npc.timeonfire;
          if PDO.PlayPainSounds {
            PlaySound(npc, GetFireAudio(npc.lastfireaudio, npc));
          }
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
            KillNPCCleanly(npc, 1);
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
        npc.WasPDODismembered = false;
        npc.lasttimescreamed = Cast<Uint32>(0);
        npc.screaminterval = 39;
        npc.screamcount = 0;
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

        if npc.WasPDODismembered && npc.screamcount <= 5 {
            if (npc.lasttimescreamed + Cast<Uint32>(npc.screaminterval)) < npc.timeincapacitated && !StatusEffectSystem.ObjectHasStatusEffect(npc, t"BaseStatusEffect.Burning") {
                npc.lasttimescreamed = npc.timeincapacitated;
                let randomnr = RandRange(1, 10);
                if randomnr < 5 && PDO.PlayPainSounds {
                    PlaySound(npc, GetFireAudio(npc.lastscreamaudio, npc));
                    npc.screamcount += 1;
                }
            }
        }
        else {
            if (npc.lasttimemoaned + Cast<Uint32>(npc.moaninterval)) < npc.timeincapacitated && !StatusEffectSystem.ObjectHasStatusEffect(npc, t"BaseStatusEffect.Burning") {
                npc.lasttimemoaned = npc.timeincapacitated;
                let randomnr = RandRange(1, 10);
                if randomnr < 5 && PDO.PlayPainSounds {
                    PlaySound(npc, GetMoanAudio(npc.lastmoanaudio, npc));
                }
            }
        }

        npc.DropHeldItems();

        if (npc.headhitcounter >= PDO.GetDSHeadshotKillThreshold()) || (npc.torsohitcounter >= PDO.GetDSTorsoshotKillThreshold()) {
          KillNPCCleanly(npc, 1);
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
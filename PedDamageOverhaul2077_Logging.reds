module PDOLogging

import PDO.*
import PDOUtils.*

public func LogNPCData(npc: ref<NPCPuppet>, hitEvent: ref<gameHitEvent>) {
    let attackData: ref<AttackData> = hitEvent.attackData;
    let PDO: ref<PedDamageOverhaul2077> = PedDamageOverhaul2077.GetInstance();
    let hitShapeType: EHitShapeType = DamageSystemHelper.GetHitShapeTypeFromData(DamageSystemHelper.GetHitShape(hitEvent));
    LogChannel(n"DEBUG", "PDO- [PDO 2077] ");
    LogChannel(n"DEBUG", "PDO-    Entity ID: " + ToString(npc.GetEntityID()));
    LogChannel(n"DEBUG", "PDO-    Entity Model/Appearance: " + ToString(npc.GetCurrentAppearanceName()));
    LogChannel(n"DEBUG", "PDO-    NPC Type: " + ToString(npc.GetNPCType()));
    LogChannel(n"DEBUG", "PDO-    To Be Incapacitated: " + ToString(npc.toBeIncapacitated));
    LogChannel(n"DEBUG", "PDO-    Health in Percent: " + ToString(GetNPCHealthInPercent(npc)));
    LogChannel(n"DEBUG", "PDO-    Health absolute: " + ToString(GetNPCHealth(npc)));
    LogChannel(n"DEBUG", "PDO-    Hit Source: " + ToString(RPGManager.GetWeaponEvolution(attackData.GetWeapon().GetItemID())));
    LogChannel(n"DEBUG", "PDO-    Is Counted as Dead: " + ToString(npc.IsDead()));
    LogChannel(n"DEBUG", "PDO-    Was PDO-Dismembered: " + ToString(npc.WasPDODismembered));
    LogChannel(n"DEBUG", "PDO-    Dying State forced (because of crippled limbs): " + ToString(npc.DyingStateForced));
    LogChannel(n"DEBUG", "PDO-    Dying State Threshold (Incapacitation): " + ToString(Cast<Float>(PDO.GetDyingStateThreshold())));
    LogChannel(n"DEBUG", "PDO- ");
    LogChannel(n"DEBUG", "PDO-     - Hit Type: " + ToString(hitShapeType));
    LogChannel(n"DEBUG", "PDO- ");
    LogChannel(n"DEBUG", "PDO-     - Headshot count: " + ToString(npc.headhitcounter));
    LogChannel(n"DEBUG", "PDO-     - - Headshot Kill Threshold: " + ToString(PDO.GetHeadshotKillThreshold()));
    LogChannel(n"DEBUG", "PDO-     - - DS Headshot Kill Threshold: " + ToString(PDO.GetDSHeadshotKillThreshold()));
    LogChannel(n"DEBUG", "PDO- ");
    LogChannel(n"DEBUG", "PDO-     - Torsoshot count: " + ToString(npc.torsohitcounter));
    LogChannel(n"DEBUG", "PDO-     - - Torso Crippling Threshold: " + ToString(PDO.GetTorsoDamagedThreshold()));
    LogChannel(n"DEBUG", "PDO-     - - Torso Kill Threshold: " + ToString(PDO.GetTorsoshotKillThreshold()));
    LogChannel(n"DEBUG", "PDO-     - - DS Torso Kill Threshold: " + ToString(PDO.GetDSTorsoshotKillThreshold()));
    LogChannel(n"DEBUG", "PDO- ");
    LogChannel(n"DEBUG", "PDO-     - Right Arm shot count: " + ToString(npc.rightarmhitcounter));
    LogChannel(n"DEBUG", "PDO-     - Left Arm shot count: " + ToString(npc.leftarmhitcounter));
    LogChannel(n"DEBUG", "PDO-     - - Arm Crippling Threshold: " + ToString(PDO.GetArmDamagedThreshold()));
    LogChannel(n"DEBUG", "PDO- ");
    LogChannel(n"DEBUG", "PDO-     - Right Leg shot count: " + ToString(npc.rightleghitcounter));
    LogChannel(n"DEBUG", "PDO-     - Left Leg shot count: " + ToString(npc.leftleghitcounter));
    LogChannel(n"DEBUG", "PDO-     - - Leg Crippling Threshold: " + ToString(PDO.GetLegDamagedThreshold()));
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
module PDO

import PDOLoop.*
import PDOUtils.*
import PDODamageUtils.*
import PDOAudioUtils.*

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
  let DyingStateThreshold: Int32 = 25;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Enable Pain Audio")
  @runtimeProperty("ModSettings.description", "Makes NPCs play pain audio more consistenly (e.g. when hit, when on fire, when in Dying State, etc.).")
  let PlayPainSounds: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Enable Gore")
  @runtimeProperty("ModSettings.description", "Makes NPCs in DyingStates easily dismembered (even while alive).")
  let EnableGore: Bool = true;

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
  @runtimeProperty("ModSettings.displayName", "Head-'Shot Points'")
  @runtimeProperty("ModSettings.description", "If set to False, the 'Shot Point' mechanic will not work for head shots.")
  let HeadshotsKill: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Head Shot Kills with Blade Weapons")
  @runtimeProperty("ModSettings.description", "If set to False, blade weapons will not kill an NPC by 'head shot', when the 'Shot Point' mechanic usually would.")
  let HeadShotsWithBladeWeapons: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Head Shot Kills with Blunt Weapons")
  @runtimeProperty("ModSettings.description", "If set to False, blunt weapons will not kill an NPC by 'head shot', when the 'Shot Point' mechanic usually would.")
  let HeadShotsWithBluntWeapons: Bool = false;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Head Shot Kills with Silenced Weapons")
  @runtimeProperty("ModSettings.description", "If set to False, silenced weapons will not kill an NPC by 'head shot', when the 'Shot Point' mechanic usually would.")
  let HeadShotsWithSilencedWeapons: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Crippling with Blade Weapons")
  @runtimeProperty("ModSettings.description", "If set to False, blade weapons will not cripple an NPC, when the 'Shot Point' mechanic usually would. This also disables torso kills by 'Shot Points' with blade weapons.")
  let CripplingWithBladeWeapons: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Crippling with Blunt Weapons")
  @runtimeProperty("ModSettings.description", "If set to False, blunt weapons will not cripple an NPC, when the 'Shot Point' mechanic usually would. (when enabled, fist fights will become much easier) This also disables torso kills by 'Shot Points' with blunt weapons.")
  let CripplingWithBluntWeapons: Bool = false;
  
  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Crippling with Silenced Weapons")
  @runtimeProperty("ModSettings.description", "If set to False, silenced weapons will not cripple an NPC, when the 'Shot Point' mechanic usually would. This also disables torso kills by 'Shot Points' with silenced weapons.")
  let CripplingWithSilencedWeapons: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Disable Crippling Melee Enemies")
  @runtimeProperty("ModSettings.description", "If set to True, enemies weilding melee weapons cannot be crippled (the melee enemy AI cannot handle being crippled, the NPC will just stand there and do nothing).")
  let DisableCripplingMeleeEnemies: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Arm Crippling")
  @runtimeProperty("ModSettings.description", "If set to False, NPC's arms can no longer be crippled. (this is for those who don't want NPCs to stop putting up a fight - because they do if both arms are crippled)")
  let CripplingArms: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Crippled Limbs Put Enemies Down v1")
  @runtimeProperty("ModSettings.description", "If set to True, NPCs will go into Dying State if both arms OR both legs are crippled.")
  let CripplingPutsNPCsDown1: Bool = false;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Crippled Limbs Put Enemies Down v2")
  @runtimeProperty("ModSettings.description", "If set to True, NPCs will go into Dying State if both arms AND both legs are crippled.")
  let CripplingPutsNPCsDown2: Bool = false;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Head Shot Kill Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to kill an NPC by head shots. (as an NPC enters the Dying State, the head 'Shot Points' get reset to 0) Only works if 'Enable Head-'Shot Points'' is enabled.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "500")
  let HeadshotKillThreshold: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "DS Head Shot Kill Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to kill an NPC by head shots when in Dying State. (as an NPC enters the Dying State, the head 'Shot Points' get reset to 0) Only works if 'Enable Head-'Shot Points'' is enabled.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "500")
  let DSHeadshotKillThreshold: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Torso Shot Kill Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to kill an NPC by torso shots. (as an NPC enters the Dying State, the 'Shot Points' get reset to 0)")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "500")
  let TorsoshotKillThreshold: Int32 = 30;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "DS Torso Shot Kill Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to kill an NPC by torso shots when in Dying State. (as an NPC enters the Dying State, the 'Shot Points' get reset to 0)")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "500")
  let DSTorsoshotKillThreshold: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Arm Shot Crippling Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to cripple an NPC's arm.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "500")
  let ArmDamagedThreshold: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Leg Shot Crippling Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to cripple an NPC's leg.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "500")
  let LegDamagedThreshold: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Torso Shot Crippling Threshold")
  @runtimeProperty("ModSettings.description", "'Shot Points' it takes to cripple an NPC's torso.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "500")
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

  public func GetDSTorsoshotKillThreshold() -> Int32 {
    return this.DSTorsoshotKillThreshold;
  }

  public func GetDSHeadshotKillThreshold() -> Int32 {
    return this.DSHeadshotKillThreshold;
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

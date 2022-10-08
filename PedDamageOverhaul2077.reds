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
  @runtimeProperty("ModSettings.displayName", "Enable for Bosses and Psychos")
  @runtimeProperty("ModSettings.description", "Makes PDO work for Bosses and Cyberpsychos (to a degree - only crippling and Dying State, no kills due to Shot Points, since it would make things too easy).")
  let EnablePDOForBosses: Bool = true;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Dying State Threshold")
  @runtimeProperty("ModSettings.description", "Health percentage threshold, under which NPCs will go into the Dying State (= incapacitated on the ground, still alive). NOTE: Values higher than 70 can cause unwanted behavior in combination with 'Enable Gore'.")
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
  let CripplingArms: Bool = false;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Crippled Limbs Put Enemies Down v1")
  @runtimeProperty("ModSettings.description", "If set to True, NPCs will go into Dying State if both arms OR both legs are crippled.")
  let CripplingPutsNPCsDown1: Bool = false;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Crippled Limbs Put Enemies Down v2")
  @runtimeProperty("ModSettings.description", "If set to True, NPCs will go into Dying State if both arms AND both legs are crippled.")
  let CripplingPutsNPCsDown2: Bool = false;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Crippled Limbs Put Melee Enemies Down")
  @runtimeProperty("ModSettings.description", "If set to True, NPCs weilding melee weapons will go into Dying State if both arms OR both legs are crippled / have accumulated enough 'Shot Points' to count as crippled.")
  let CripplingPutsMeleeNPCsDown: Bool = true;

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
  @runtimeProperty("ModSettings.displayName", "Weapon Type Modifier: Tech")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is of type 'Tech' (stacks with 'Weapon Family Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let TechDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Type Modifier: Smart")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is of type 'Smart' (stacks with 'Weapon Family Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let SmartDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Type Modifier: Power")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is of type 'Power' (stacks with 'Weapon Family Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let PowerDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Type Modifier: Blade")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is of type 'Blade' (stacks with 'Weapon Family Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let BladeDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Type Modifier: Blunt")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is of type 'Blunt' (stacks with 'Weapon Family Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let BluntDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Fists")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Fist' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let FistDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Melee")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is 'Melee' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let MeleeDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Axe")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is an 'Axe' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let AxeDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Hammer")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Hammer' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let HammerDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Chainsword")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Chainsword' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let ChainswordDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Katana")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Katana' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let KatanaDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Knife")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Knife' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let KnifeDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Long Blade")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Long Blade' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let LongBladeDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Short Blade")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Short Blade' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let ShortBladeDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Machete")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Machete' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let MacheteDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: One-Handed Club")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'One-Handed Club' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let OneHandedClubDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Two-Handed Club")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Two-Handed Club' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let TwoHandedClubDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Assault Rifle")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is an 'Assault Rifle' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let AssaultRifleDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Handgun")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Handgun' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let HandgunDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Heavy Machine Gun")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Heavy Machine Gun' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let HeavyMachineGunDamageModifier: Float = 1.0;
  
  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Light Machine Gun")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Light Machine Gun' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let LightMachineGunDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Precision Rifle")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Precision Rifle' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let PrecisionRifleDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Revolver")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Revolver' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let RevolverDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Rifle")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Rifle' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let RifleDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Shotgun")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Shotgun' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let ShotgunDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Dual Shotgun")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Dual Shotgun' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let DualShotgunDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Submachine Gun")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Submachine Gun' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let SubmachineGunDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Sniper Rifle")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Sniper Rifle' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let SniperRifleDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Cyberware Strong Arms")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is 'Cyberware Strong Arms' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let CybStrongArmsDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Cyberware Nano Wires")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is 'Cyberware Nano Wires' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let CybNanoWiresDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Cyberware Mantis Blades")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is 'Cyberware Mantis Blades' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let CybMantisBladesDamageModifier: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Ped Damage Overhaul 2077")
  @runtimeProperty("ModSettings.displayName", "Weapon Family Modifier: Cyberware Rocket Launcher")
  @runtimeProperty("ModSettings.description", "'Shot Points' will be multiplied with this factor if the weapon dealing the damage is a 'Cyberware Rocket Launcher' (stacks with 'Weapon Type Modifier').")
  @runtimeProperty("ModSettings.step", "0.01")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "5.0")
  let CybLauncherDamageModifier: Float = 1.0;

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

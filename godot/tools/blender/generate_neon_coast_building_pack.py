# NEON COAST — procedural modular building pack
# Run with: blender --background --python generate_neon_coast_building_pack.py
# Tested by design against Blender 4.x API; requires Blender to execute/export.
import bpy, math, os
from mathutils import Vector

OUT = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../assets/generated/buildings"))
os.makedirs(OUT, exist_ok=True)

def clear_scene():
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)
    for c in list(bpy.data.collections):
        if c.name != "Collection":
            bpy.data.collections.remove(c)

def mat(name, color, roughness=0.78, metallic=0.0):
    m=bpy.data.materials.new(name); m.diffuse_color=(*color,1)
    m.use_nodes=True
    bs=m.node_tree.nodes.get("Principled BSDF")
    bs.inputs["Base Color"].default_value=(*color,1)
    bs.inputs["Roughness"].default_value=roughness
    bs.inputs["Metallic"].default_value=metallic
    return m

PLASTER=mat("NC_Warm_Plaster",(0.72,.61,.47))
CREAM=mat("NC_Salt_Cream",(.88,.81,.66))
TEAL=mat("NC_Sea_Glass_Teal",(.045,.34,.34))
DARK=mat("NC_Deep_Charcoal",(.075,.105,.12))
GLASS=mat("NC_Blue_Glass",(.055,.22,.29),.22,.25)
WOOD=mat("NC_Sun_Bleached_Wood",(.39,.25,.14))
ROOF=mat("NC_Terracotta",(.42,.16,.105))
CONCRETE=mat("NC_Concrete",(.31,.34,.33))
METAL=mat("NC_Painted_Metal",(.12,.18,.19),.42,.65)
YELLOW=mat("NC_Sign_Yellow",(.93,.56,.12))

def cube(name, loc, scale, material, bevel=.035, collection=None):
    bpy.ops.mesh.primitive_cube_add(size=1, location=loc)
    o=bpy.context.object; o.name=name; o.dimensions=scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    if material: o.data.materials.append(material)
    if bevel:
        mod=o.modifiers.new("Soft_Edge_Bevel","BEVEL"); mod.width=bevel; mod.segments=2
        o.modifiers.new("Weighted_Corner_Normals","WEIGHTED_NORMAL")
    if collection:
        for c in list(o.users_collection): c.objects.unlink(o)
        collection.objects.link(o)
    return o

def collection(name):
    c=bpy.data.collections.new(name); bpy.context.scene.collection.children.link(c); return c

def building_shell(col, name, w=6.0, d=5.0, h=6.0, wall=PLASTER):
    cube(name+"_MainVolume",(0,0,h/2),(w,d,h),wall,.055,col)
    cube(name+"_Foundation",(0,0,.18),(w+.12,d+.12,.36),CONCRETE,.035,col)
    # flat roof parapet; modular silhouette
    cube(name+"_RoofSlab",(0,0,h+.08),(w+.18,d+.18,.22),ROOF,.025,col)
    for x in (-w/2+.12,w/2-.12):
        cube(name+"_ParapetSide",(x,0,h+.42),(.22,d+.15,.62),CREAM,.025,col)
    cube(name+"_ParapetBack",(0,d/2-.1,h+.42),(w,.22,.62),CREAM,.025,col)

def window(col, x, y, z, width=1.15, height=1.45):
    cube("Window_Recess",(x,y-.035,z),(width+.18,.12,height+.18),DARK,.025,col)
    cube("Window_Glass",(x,y-.105,z),(width,.055,height),GLASS,.018,col)
    cube("Window_Sill",(x,y-.17,z-height/2-.06),(width+.22,.28,.12),CREAM,.025,col)
    cube("Window_Mullion",(x,y-.145,z),(.055,.055,height),METAL,.008,col)

def front_facade(col, w, h, floor_count=2, shop=False):
    # Front faces toward -Y
    if shop:
        cube("Shop_Glazing",(0,-2.56,1.45),(2.65,.08,2.25),GLASS,.025,col)
        for x in (-1.38,1.38):
            cube("Shop_Frame",(x,-2.64,1.45),(.12,.12,2.45),METAL,.015,col)
        cube("Shop_Awning",(0,-2.9,2.85),(3.25,.85,.16),TEAL,.035,col)
        for x in (-1.3,1.3):
            cube("Awning_Support",(x,-2.62,2.5),(.08,.08,.7),METAL,.01,col)
    else:
        cube("Entry_Door",(-w*.27,-2.56,1.15),(.95,.1,2.15),WOOD,.025,col)
        cube("Door_Glass",(-w*.27,-2.625,1.55),(.62,.035,.95),GLASS,.012,col)
    for floor in range(floor_count):
        z=3.55+floor*2.55
        for x in (-w*.28,w*.28):
            window(col,x,-2.56,z,1.12,1.48)
        cube("Facade_BeltCourse",(0,-2.58,3.0+floor*2.55),(w,.16,.13),CREAM,.018,col)
    # balcony rails on upper level
    if floor_count>1:
        for x in (-w*.28,w*.28):
            cube("Balcony_Deck",(x,-2.95,4.15),(1.48,.72,.12),CONCRETE,.025,col)
            cube("Balcony_Rail_Top",(x,-3.27,4.68),(1.52,.07,.07),METAL,.015,col)
            for dx in (-.68,-.34,0,.34,.68):
                cube("Balcony_Rail_Post",(x+dx,-3.27,4.42),(.045,.05,.5),METAL,.008,col)

def add_roof_details(col, w, d, h):
    cube("Rooftop_Access",(w*.28,d*.22,h+.75),(1.1,1.25,1.25),PLASTER,.04,col)
    for x in (-w*.35,w*.35):
        cube("Roof_Vent",(x,d*.25,h+.55),(.48,.42,.55),METAL,.04,col)

def export_collection(col, filename):
    bpy.ops.object.select_all(action="DESELECT")
    for o in col.objects: o.select_set(True)
    bpy.context.view_layer.objects.active=next(iter(col.objects),None)
    path=os.path.join(OUT,filename+".glb")
    bpy.ops.export_scene.gltf(filepath=path, export_format="GLB", use_selection=True,
                              export_apply=True, export_yup=True)
    print("EXPORTED",path)

def make_building(name,w,d,h,shop=False,wall=PLASTER):
    col=collection(name)
    building_shell(col,name,w,d,h,wall)
    front_facade(col,w,h,2,shop)
    add_roof_details(col,w,d,h)
    # side windows, aligned on the east wall
    for z in (2.1,4.7):
        cube("Side_Window_Recess",(w/2+.025,0,z),(.08,1.15,1.35),DARK,.02,col)
        cube("Side_Window_Glass",(w/2+.075,0,z),(.04,.98,1.18),GLASS,.01,col)
    # shop sign as blank teal panel; lettering added later as a texture
    if shop:
        cube("Sign_Panel",(0,-2.69,3.28),(2.4,.12,.42),YELLOW,.025,col)
    export_collection(col,name.lower())

def make_small_props():
    col=collection("NC_Street_Props")
    # lamp post + stylized lantern
    cube("Lamp_Base",(-4,0,.18),(.42,.42,.36),CONCRETE,.05,col)
    cube("Lamp_Post",(-4,0,2.1),(.13,.13,3.7),METAL,.025,col)
    cube("Lamp_Arm",(-3.58,0,3.85),(.9,.12,.12),METAL,.025,col)
    cube("Lamp_Lantern",(-3.18,0,3.65),(.48,.42,.36),YELLOW,.07,col)
    # bench
    for x in (-1.4,1.4):
        cube("Bench_Leg",(x,0,.42),(.14,.14,.8),METAL,.025,col)
    cube("Bench_Seat",(0,0,.78),(3.1,.62,.16),WOOD,.04,col)
    cube("Bench_Back",(0,.24,1.35),(3.1,.14,1.05),WOOD,.04,col)
    # bin
    cube("Street_Bin",(3.6,0,.65),(.72,.72,1.3),TEAL,.08,col)
    cube("Street_Bin_Lid",(3.6,0,1.34),(.82,.82,.16),METAL,.04,col)
    # bollards
    for x in (5.1,6.0,6.9):
        cube("Bollard",(x,0,.48),(.28,.28,.96),YELLOW,.06,col)
    export_collection(col,"nc_street_props")

clear_scene()
make_building("NC_Coast_Apartment",6.2,5.2,6.0,False,PLASTER)
make_building("NC_Harbor_Cafe",6.2,5.2,6.0,True,CREAM)
make_building("NC_Teal_Corner_Block",7.2,5.8,8.0,False,TEAL)
make_small_props()
print("NEON COAST asset pack generation finished.")

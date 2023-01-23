function make_model(grid_type,p)
    gmsh.initialize()
    gmsh.option.setNumber("General.Terminal", 1)


   if grid_type == "double_slit" # 
        
        side_x, side_y, slit_x, slit_y, spa, lc = p
        mid_x=side_x/2.0
        mid_y=side_y/2.0
        gmsh.model.add("double_slit")
        
        gmsh.model.geo.addPoint(0, 0, 0, lc, 1)
        gmsh.model.geo.addPoint(mid_x-slit_x/2, 0,  0, lc, 2)
        gmsh.model.geo.addPoint(mid_x-slit_x/2, mid_y-slit_y/2-spa,  0, lc, 3)
        gmsh.model.geo.addPoint(mid_x+slit_x/2, mid_y-slit_y/2-spa,  0, lc, 4)
        gmsh.model.geo.addPoint(mid_x+slit_x/2, 0,  0, lc, 5)
        gmsh.model.geo.addPoint(side_x, 0, 0, lc, 6)
        gmsh.model.geo.addPoint(side_x, side_y, 0, lc, 7)
        gmsh.model.geo.addPoint(mid_x+slit_x/2, side_y,  0, lc, 8)
        gmsh.model.geo.addPoint(mid_x+slit_x/2, mid_y+slit_y/2+spa,  0, lc, 9)
        gmsh.model.geo.addPoint(mid_x-slit_x/2, mid_y+slit_y/2+spa,  0, lc, 10)
        gmsh.model.geo.addPoint(mid_x-slit_x/2, side_y,  0, lc, 11)
        gmsh.model.geo.addPoint(0, side_y, 0, lc, 12)

        # make the square boundary
        gmsh.model.geo.addLine(1, 2, 1)
        gmsh.model.geo.addLine(2, 3, 2)
        gmsh.model.geo.addLine(3, 4, 3)
        gmsh.model.geo.addLine(4, 5, 4)
        gmsh.model.geo.addLine(5, 6, 5)
        gmsh.model.geo.addLine(6, 7, 6)
        gmsh.model.geo.addLine(7, 8, 7)
        gmsh.model.geo.addLine(8, 9, 8)
        gmsh.model.geo.addLine(9, 10, 9)
        gmsh.model.geo.addLine(10, 11, 10)
        gmsh.model.geo.addLine(11, 12, 11)
        gmsh.model.geo.addLine(12, 1, 12)

        gmsh.model.geo.addCurveLoop([1, 2, 3, 4,5,6,7,8,9,10,11,12], 14) #the rectangle
        gmsh.model.geo.synchronize()

        #gmsh.model.geo.addPhysicalGroup(1, [10], 11 )
        gmsh.model.geo.addPhysicalGroup(1, [1, 2, 3, 4,5,6,7,8,9,10,11,12], 15 )
        gmsh.model.setPhysicalName(1, 15, "ext")
        gmsh.model.geo.synchronize()

        # add the wall
        
        gmsh.model.geo.addPoint(mid_x-slit_x/2, mid_y-slit_y/2, 0, lc, 16)
        gmsh.model.geo.addPoint(mid_x+slit_x/2, mid_y-slit_y/2,  0, lc, 17)
        gmsh.model.geo.addPoint(mid_x+slit_x/2, mid_y+slit_y/2, 0, lc, 18)
        gmsh.model.geo.addPoint(mid_x-slit_x/2, mid_y+slit_y/2, 0, lc, 19)

        gmsh.model.geo.addLine(16, 17, 16)
        gmsh.model.geo.addLine(17, 18, 17)
        gmsh.model.geo.addLine(18, 19, 18)
        gmsh.model.geo.addLine(19, 16, 19)

        gmsh.model.geo.addCurveLoop([16, 17, 18, 19], 20) 
        gmsh.model.geo.synchronize()

        gmsh.model.geo.addPhysicalGroup(1, [16, 17, 18, 19], 21 )
        gmsh.model.setPhysicalName(1, 21, "wall")
        gmsh.model.geo.synchronize()

        # make the surface

        gmsh.model.geo.addPlaneSurface([14,20], 100) #the surface
        gmsh.model.geo.synchronize()

        gmsh.model.addPhysicalGroup(2, [100], 101)
        gmsh.model.setPhysicalName(2, 101, "surface")
        gmsh.model.geo.synchronize()

        gmsh.model.mesh.generate(2)
        gmsh.write("models/double_slit.msh")
        gmsh.finalize()
        model = GmshDiscreteModel("models/double_slit.msh")
    end
    return model
end
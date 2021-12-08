# separate design.sql into designTable.sql and designConstraints.sql
with open("design.sql", "rb") as design:
    with open("designTable.sql", "w") as table:
        while True:
            line = design.readline()
            if not line:
                break
            if not line.startswith(b"ALTER"):
                table.write(line.decode("utf-8"))
            else:
                # revert this line
                design.seek(-len(line), 1)
                break
    with open("designConstraints.sql", "w") as constraints:
        while True:
            line = design.readline()
            if not line:
                break
            constraints.write(line.decode("utf-8"))

# write a design_.sql with designBootstrap.sql in the middle
with open("design_.sql", "w") as mainf:
    mainf.write(f"@designTable.sql\n")
    mainf.write(f"@designBootstrap.sql\n")
    mainf.write(f"@designConstraints.sql\n")

with open("resetDesign.sql", "w") as resf:
    resf.write("@designDelete.sql\n")
    resf.write("@design_.sql\n")
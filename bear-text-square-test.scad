module t(t, s = 18, style = ":style=Bold", spacing = 1, height = 4) {
    linear_extrude(height = height)
        text(t, size = s,
            spacing=spacing,
            halign = "center",
            valign = "center",
            font = str("Liberation Sans", style),
            $fn = 50);
}

union() {
    difference() {
        cube([50, 50, 10], center = true);
        translate([0, 0, 5])
            cube([45, 45, 10], center = true);
    }

    translate([0, 0, -1])
        t("Bear", s = 13, height = 5);
}
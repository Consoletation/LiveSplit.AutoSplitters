state("simmiland" , "20210720") {
    double state  : 0x0043550C, 0x1C, 0x60, 0x10, 0xEA4, 0x740;
    double timer  : 0x0043550C, 0x1C, 0x60, 0x10, 0xBE0, 0x610;
    double iq     : 0x0043550C, 0x0,  0x60, 0x10, 0xB50, 0x0;
    double prayer : 0x0043550C, 0x0,  0x60, 0x10, 0xBD4, 0x0, 0xA0;
}

init {
    print("[simmiland asl] init");
    refreshRate = 60;
    vars.currentSplit = 0;
    vars.desiredSplit = 0;
}

reset {
    if (current.timer < old.timer) {
        vars.currentSplit = 0;
        vars.desiredSplit = 0;
        return true;
    }
}

start {
    if (current.timer > 0) {
        return true;
    }
}

update {
    if (current.state == 2)
        // The End
        vars.desiredSplit = 4;
    else if (current.iq >= 141)
        // Sky Tower
        vars.desiredSplit = 3;
    else if (current.iq >= 101)
        // Town Center
        vars.desiredSplit = 2;
    else if (current.iq >= 71)
        // Farmhouse
        vars.desiredSplit = 1;
}

split {
    if (vars.desiredSplit > vars.currentSplit) {
        vars.currentSplit += 1;
        return true;
    }
}

isLoading {
    return true;
}

gameTime {
    return TimeSpan.FromSeconds(current.timer);
}

state("simmiland" , "20210720") {
    double timer  : 0x0043550C, 0x1C, 0x60, 0x10, 0xBE0, 0x610;
    double iq     : 0x0043550C, 0x0,  0x60, 0x10, 0xB50, 0x0;
    double prayer : 0x0043550C, 0x0,  0x60, 0x10, 0xBD4, 0x0, 0xA0;
}

startup {
    print("[simmiland asl] startup");
    refreshRate = 60;
}

reset {
    if (current.timer < old.timer) {
        return true;
    }
}

start {
    if (current.timer > 0) {
        return true;
    }
}

isLoading {
    return true;
}

gameTime {
    return TimeSpan.FromSeconds(current.timer);
}

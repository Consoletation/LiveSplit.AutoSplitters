state("simmiland" , "20210720") {
    double timer  : 0x0003B898, 0x7C, 0x4, 0x50, 0x40, 0x68, 0x490;
    double iq     : 0x0003B898, 0x7C, 0x4, 0x50, 0x40, 0x68, 0xAD0;
    double prayer : 0x0003B898, 0x7C, 0x4, 0x50, 0x40, 0x360;
}

startup {
    print("[simmiland asl] startup");
    refreshRate = 60;
}

reset {
    if (current.timer < 0.01) {
        return true;
    }
}

start {
    if (current.timer > 0.01) {
        return true;
    }
}

isLoading {
    return true;
}

gameTime {
    return TimeSpan.FromSeconds(current.timer);
}

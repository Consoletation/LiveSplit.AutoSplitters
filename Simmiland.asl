state("simmiland" , "20210720") {
    double state  : 0x0043550C, 0x1C, 0x60, 0x10, 0x340, 0x620;
    double seed   : 0x0043550C, 0x1C, 0x60, 0x10, 0xA3C, 0x650;
    double timer  : 0x0043550C, 0x1C, 0x60, 0x10, 0x604, 0x80;
    double iq     : 0x0043550C, 0x0, 0x60, 0x10, 0xB50, 0x0;
    double prayer : 0x0043550C, 0x0,  0x60, 0x10, 0x190, 0x0, 0x60;
    double cardsL : 0x0043550C, 0x1C, 0x178, 0x60, 0x10, 0x43C, 0x0;
    double cardsT : 0x0043550C, 0x1C, 0x60, 0x10, 0x448, 0x60;
}

startup {
    refreshRate = 60;
    vars.tcs = new List<dynamic>();

    // Text component mapping
    foreach (dynamic component in timer.Layout.Components)
        if (component.GetType().Name == "TextComponent")
            vars.tcs.Add(component.Settings);

    var index = 0;
    foreach (dynamic tcs in vars.tcs) {
        if (index == 0)
            tcs.Text1 = "Seed:";
        else if (index == 1)
            tcs.Text1 = "Deck:";
        else if (index == 2)
            tcs.Text1 = "P: ?  C: ?  IQ: ?";
        index++;
    }
}

init {
    current.split = 0;
}

update {
    // Split updates
    if (current.state == 2)
        current.split = 4; // The End
    else if (current.iq >= 141)
        current.split = 3; // Sky Tower
    else if (current.iq >= 101)
        current.split = 2; // Town Center
    else if (current.iq >= 71)
        current.split = 1; // Farmhouse

    // Text Component updates
    foreach (dynamic tcs in vars.tcs) {
        if (tcs.Text1 == "Seed:" && current.seed != old.seed)
            tcs.Text2 = current.seed.ToString();
        else if (tcs.Text1 == "Deck:") {
            if (current.cardsT < 250)
                tcs.Text2 = "Reduced";
            else
                tcs.Text2 = "Full";
        }
        else if (tcs.Text1.StartsWith("P:"))
            tcs.Text1 = "P: " + current.prayer.ToString()
                    + "  C: " + current.cardsL.ToString("F0") + "/" + current.cardsT.ToString("F0")
                    + "  IQ: " + current.iq.ToString();
    }
}

reset {
    if (current.timer < old.timer) {
        current.split = 0;
        return true;
    }
}

start {
    return current.timer > 0;
}

split {
    return current.split - old.split == 1;
}

isLoading {
    return true;
}

gameTime {
    return TimeSpan.FromSeconds(current.timer);
}

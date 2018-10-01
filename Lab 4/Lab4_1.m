%{
    *fluike visibility applies when diving

    Killer whale: 
        fluke = 6 - 8 m (small)
        fluke visibility = false
        dorsal fin = (true) tall, pointed
        dorsal fin visibility = often clearly
        blow water = often
    
    Beluga whale:
        fluke visibility = false
        dorsal fin = false
        
    Narwhal whale:
        general size = < 5m (small)
        tusk = single, extraordinarily long
        fluke visibility = true
        dorsal fin = false
    
    Bowhead whale:
        fluke visibility = true
        dorsal fin = false
        size = untill 20m (large)

    Blue whale:
        size = over 30m (largest)
        fluke size = big
        fluke visibility = true
        dorsal fin size = small
        dorsal fin visibility = true

    q1: fluke visibility true?
            left;
            q2: tusk true?
                left;
            false?
                right;
                    q3: doral fin true?
                        left;
                    false?
                        right
        false?
            right;
                q4: Dorsal fin true?
                    left
                false?
                    right


    Fluke visibility?:
        true:
            *Blue whale
            *Bowhead whale
            *Narwhal whale
                Tusk?:
                    true:
                        *Narwhal whale
                    false:
                        *Blue whale
                        *Bowhead whale
                        Dorsal fin?
                            true:
                                *Blue whale
                            false:
                                *Bowhead whale
        false:
            *Beluga whale
            *Killer whale
                Dorsal fin?
                    true:
                        *Killer whale
                    false:
                        *Beluga whale
            
%}
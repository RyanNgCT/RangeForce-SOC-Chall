rule pe {
        strings:
                $mb = {4D 5A}
        condition:
                $mb at 0
}

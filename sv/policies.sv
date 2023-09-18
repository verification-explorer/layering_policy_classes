// Ports power request are higher than chip power allocation
class over_pwr_req_pcy extends rand_policy_base #(pwr_mng_chip);

    constraint over_pwr_req_c {
        item.ports.sum(port) with (int'(port.pwr_req)) > item.chip_pwr_alloc ;
    }

endclass

// Ports power request are lower than chip power allocation
class under_pwr_req_pcy extends rand_policy_base #(pwr_mng_chip);

    constraint over_pwr_req_c {
        item.chip_pwr_alloc > item.ports.sum(port) with (int'(port.pwr_req)) ;
    }

endclass

// Chip power allocation must be higher than ports with index equal [0,1,2,3]
class location_pwr_req_pcy extends rand_policy_base #(pwr_mng_chip);
    
    constraint location_pwr_req {
        item.ports.sum(port) with (int'(port.pwr_req * (port.index < 4))) < item.chip_pwr_alloc;
    }

endclass

// Set to a number greater than or equal to the minimum and less than or equal to the maximum number of failures.
class min_num_of_failures_pcy extends rand_policy_base #(pwr_mng_chip);

    int min_failures;
    int max_failures;
    randc bit [(`NUM_PORTS-1):0] selected_ports;

    constraint min_num_failures_c {

        $countones(selected_ports) inside {[min_failures:max_failures]};

        foreach(selected_ports[idx]) {
            if (selected_ports[idx]) {
                item.ports[idx].failure != NOFL;
            }
        }
    }

    function new (int num_failures, max_failures);
        this.min_failures=num_failures;
        this.max_failures=max_failures;
    endfunction

endclass

// Set failure mode to 4 initial ports
class location_failure_pcy extends min_num_of_failures_pcy;

    constraint initial_4_ports {
        selected_ports[7:4] == 0;
    }

    constraint failure_4_ports {
        foreach(selected_ports[idx]) {
            if (selected_ports[idx]) {
                item.ports[idx].failure inside {OVRC, SHRT};
            }
        }
    }

    function new;
        super.new(1,4);
    endfunction

endclass

// Set priorities to ports
class location_priority_pcy extends rand_policy_base #(pwr_mng_chip);

    constraint priority_location {
        foreach (item.prio[idx]) {
            if (idx<4) {
                item.prio[idx] inside {[HIGH:HIGHEST]};
            }
            else {
                item.prio[idx] inside {[LOW:MEDIUM]};
            }
        }
    }

endclass


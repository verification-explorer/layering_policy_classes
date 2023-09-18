class sys_test extends uvm_test;

    pwr_mng_chip            chip;
    over_pwr_req_pcy        over_pwr_req;
    under_pwr_req_pcy       under_pwr_req;
    min_num_of_failures_pcy min_num_of_failures;
    location_failure_pcy    location_failure;
    location_priority_pcy   location_priority;
    location_pwr_req_pcy    location_pwr_req;

    `uvm_component_utils(sys_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase (uvm_phase phase);

        chip = new(.num_ports(`NUM_PORTS));

        // Confirm that the system accurately follows channel priority when activating power channels
        // in response to requests for power exceeding the current system capacity
        // Ports should not initiate any failure mode
        over_pwr_req=new;
        chip.chip_power_policies = {over_pwr_req};
        if (!chip.randomize()) `uvm_error(get_name(), "Failed to randomize sys power policies")
        $display(chip.convert2string());

        // Among the ports, a minimum of 2 and maximum of 4 should exhibit a failure mode,
        // while those in non-failure mode should maintain their power requests unchanged
        chip.chip_power_policies.delete();
        chip.chip_pwr_alloc.rand_mode(OFF);
        chip.prio.rand_mode(OFF);
        foreach (chip.ports[idx]) chip.ports[idx].pwr_req.rand_mode(OFF);
        min_num_of_failures=new(2,4);
        chip.chip_power_policies = {min_num_of_failures};
        if (!chip.randomize()) `uvm_error(get_name(), "Failed to randomize sys power policies")
        $display(chip.convert2string());

        // Remove failure mode from all the ports
        chip.chip_power_policies.delete();
        min_num_of_failures=new(0,0);
        chip.chip_power_policies = {min_num_of_failures};
        if (!chip.randomize()) `uvm_error(get_name(), "Failed to randomize sys power policies")
        $display(chip.convert2string());

        // Assign a greater amount of power to the chip than what the ports have requested
        // and then verify that all ports have been activated
        chip.chip_power_policies.delete();
        chip.chip_pwr_alloc.rand_mode(ON);
        under_pwr_req=new;
        chip.chip_power_policies = {under_pwr_req};
        if (!chip.randomize()) `uvm_error(get_name(), "Failed to randomize sys power policies")
        $display(chip.convert2string());

        // For the initial 4 ports, introduce a minimum of 1 SHORT failure or 1 OVERC failure. [7:4] ports are NOF
        // For the initial 4 ports, all priorities should be higher or equal to HIGH, for [7:4] lower than HIGH
        // The allocation of power to the chip should exceed the power requests of the initial 4 ports but remain below the power requests of all ports
        chip.chip_power_policies.delete();
        chip.prio.rand_mode(ON);
        chip.chip_pwr_alloc.rand_mode(ON);
        location_failure=new;
        location_priority=new;
        location_pwr_req=new;
        chip.chip_power_policies = {location_failure, location_priority, over_pwr_req, location_pwr_req};
        if (!chip.randomize()) `uvm_error(get_name(), "Failed to randomize sys power policies")
        $display(chip.convert2string());

    endtask

endclass

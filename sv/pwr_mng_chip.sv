class pwr_mng_chip;

    // Properties
    int num_ports;
    rand pwr_mng_port  ports[];
    rand priority_type prio[];
    rand int chip_pwr_alloc;
    rand rand_policy_base #(pwr_mng_chip) chip_power_policies[$];

    // Up to maximum power allocated for default case
    constraint max_chip_pwr_alloc_c {
      chip_pwr_alloc inside {[0: num_ports * 50]};
    }

    // Constructor
    function new (int num_ports);
      this.num_ports=num_ports;
      prio=new[num_ports];
      ports=new[num_ports];
      foreach (ports[idx]) ports[idx]=new($sformatf("port_%0d",idx));
    endfunction

    // Set this handle for all policy classes
    function void pre_randomize();
      foreach (chip_power_policies[idx]) chip_power_policies[idx].set_item(this);
    endfunction

    function string convert2string();
      string s="";
      $sformat(s,"%s ----------------------\n",s);
      $sformat(s,"%s chip_pwr_alloc : %0d\n",s,chip_pwr_alloc);
      $sformat(s,"%s ----------------------\n",s);
      $sformat(s,"%s ports_pwr_req  : %0d\n",s,ports.sum(item) with (int'(item.pwr_req)));
      $sformat(s,"%s ---------------------------------------------------\n",s);
      $sformat(s,"%s | port name | power_request | fault_type | priority\n",s);
      $sformat(s,"%s ---------------------------------------------------\n",s);
      foreach(ports[idx]) $sformat(s,"%s %s       | %s\n",s,ports[idx].add_line(),prio[idx].name());
      $sformat(s,"%s ---------------------------------------------------\n",s);
      return s;
    endfunction

  endclass

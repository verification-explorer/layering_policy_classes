class pwr_mng_port;

  string name;

  rand power_request_type pwr_req;
  rand failure_type       failure;

  // No failre is the default condition
  constraint failre_c{
    soft failure==NOFL;
  }

  function new (string name);
    this.name=name;
  endfunction

  function string add_line();
    string s="";
    $sformat(s,"%s|  %s",s,name);
    $sformat(s,"%s   |  %0d",s,pwr_req);
    $sformat(s,"%s           | %s",s,failure.name());
    return s;
  endfunction

endclass

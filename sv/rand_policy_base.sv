class rand_policy_base #(type T=uvm_object);
    T item;
    virtual function void set_item (T item);
      this.item=item;
    endfunction
  endclass

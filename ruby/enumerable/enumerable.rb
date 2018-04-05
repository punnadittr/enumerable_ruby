module Enumerable
    def my_each
        i = 0
        arr = self.to_a
        while i < self.size
            yield arr[i]
            i += 1
        end
        self
    end
    def my_each_with_index
        i = 0
        arr = self.to_a
        while i < self.size
            yield arr[i], i
            i += 1
        end
        self
    end
    def my_select
        arr = self.to_a
        arr_return = Array.new
        i = 0
        while i < self.size
            if yield(arr[i])
                arr_return.push(arr[i])
            end
            i += 1
        end
        arr_return
    end
    def my_all?
        arr = self.to_a
        false_counter = 0
        i = 0
        while i < self.size
            break if false_counter > 0
            if block_given?
                if yield(arr[i]) == false
                    false_counter += 1
                end
            elsif arr[i].nil? or arr[i] == false
                false_counter += 1
            end
            i += 1
        end
        false_counter == 0 ? true : false
    end
    def my_any?
        arr = self.to_a
        true_counter = 0
        i = 0
        while i < self.size
            break if true_counter > 0
            if block_given?
                if yield(arr[i]) == true
                    true_counter += 1
                end
            elsif arr[i] != nil and arr[i] != false
                true_counter += 1
            end
            i += 1
        end
        true_counter == 0 ? false : true
    end
    def my_none?
        arr = self.to_a
        true_counter = 0
        i = 0
        while i < self.size
            break if true_counter > 0
            if block_given?
                if yield(arr[i]) == true
                    true_counter += 1
                end
            elsif arr[i] != nil and arr[i] != false
                true_counter += 1
            end
            i += 1
        end
        true_counter == 0 ? true : false
    end
    def my_count(item = nil)
        arr = self.to_a
        counter = 0
        i = 0
        return self.size if item.nil? and block_given? == false
        while i < self.size
            if block_given?
                counter += 1 if yield(arr[i]) == true
            else
                counter += 1 if arr[i] == item
            end
            i += 1
        end
        counter
    end
    def my_map(proc = nil)
        arr = self.to_a
        new_arr = Array.new
        i = 0
        while i < self.size
            if block_given?
                new_arr << yield(arr[i])
            else
                new_arr << proc.call(arr[i])
            end
            i += 1
        end
        new_arr
    end
    def my_inject(arg1 = nil, arg2 = nil)
        arr = self.to_a
        memo = arr[0]
        i = 1
        if arg2 
            i = 0 
            sym = arg2 
            memo = arg1 
        else 
            sym = arg1 
        end
        if block_given? and arg1
            i = 0 
            memo = arg1 
        end
        if block_given?
            while i < self.size
                memo = yield memo, arr[i]
                i += 1
            end
        else
           while i < self.size
                memo = memo.send(sym, arr[i])
                i += 1
           end
        end
        memo
    end
end
   
=begin
## Test Suite From Ruby 2.3.4 Docs @ http://ruby-doc.org/ ##

#SELECT
(1..10).my_select { |i|  i % 3 == 0 }           #=> [3, 6, 9]
[1,2,3,4,5].my_select { |num|  num.even?  }     #=> [2, 4]

#ALL?
%w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
%w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
[nil, true, 99].my_all?                              #=> false

#ANY?
%w[ant bear cat].any? { |word| word.length >= 3 } #=> true
%w[ant bear cat].any? { |word| word.length >= 4 } #=> true
[nil, true, 99].any?                              #=> true

#NONE?
%w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
%w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
[].my_none?                                           #=> true
[nil].my_none?                                        #=> true
[nil, false].my_none?                                 #=> true
[nil, false, true].my_none?                           #=> false

#COUNT
ary = [1, 2, 4, 2]
ary.my_count                    #=> 4
ary.my_count(2)                 #=> 2
ary.my_count{ |x| x%2==0 }      #=> 3

#MAP
(1..4).my_map { |i| i*i }       #=> [1, 4, 9, 16]
(1..4).my_map { "cat"  }        #=> ["cat", "cat", "cat", "cat"]


#INJECT
(5..10).my_inject(:+)                             #=> 45
(5..10).my_inject { |sum, n| sum + n }            #=> 45
(5..10).my_inject(1, :*)                          #=> 151200
(5..10).my_inject(1) { |product, n| product * n } #=> 151200
longest = %w{ cat sheep bear }.my_inject do |memo, word|
   memo.length > word.length ? memo : word
end
longest                                        #=> "sheep"

def multiply_els(array)
    array.my_inject(:*)
end
function [Mean, STD, Median] = VectorStatistics(v)
    %{
    Description:
        Function that calculates the mean, standard deviation, and median.
    
    Inputs:
        v:         vector of arbitrary length
    
    Outputs:
        Mean:      mean of vector
        STD:       standard deviation of vector
        Median:    median of vector
    
    %}
   
    % This calculates the mean
    v_length = length(v); 
    v_sum = sum(v); 
    Mean = v_sum/v_length; 
   
    % This calculates the standard deviation
    STD = 0; 
    for i = 1:vec_length 
        STD = STD + (v(i) - Mean)/v_length; 
    end
    
    % This calculates the median 
    sorted_v = sort(v);
    if mod(v_length, 2) == 0 
        middle = v_length/2;
        Median = sorted_v(middle) + sorted_v(middle + 1);
    else 
        middle = (v_length + 1)/2; 
        Median = sorted_v(middle); 
    end
end
        
       
   
   
   
%% Matlab Tutorial
% ENAS 991 etc. Integrated Workshop
% By Jack Treado and Peter Williams

clear;
close all;
clc;

%% Section 0: Scripts and Formatting
% Before you begin this tutorial, you should familiarize yourself with the
% following concepts in MATLAB: command line, workspace, script, path. If
% you aren't familiar, let a TA know once we get going and we'll quickly
% review some MATLAB basics. 
% 
% In general while coding, it is helpful to thoroughly comment your code so
% that someone (including you at a later date) can read through it more
% thoroughly and identify what each part of the code does. For the purposes
% of this and other classes, the better you comment your code, the easier
% it is for TAs to grade.
% 
% Every script will have sections, which are demarcated by two percentage
% signs (%%) like you see above. The section will be highlighted in yellow,
% but more importantly if you press command-Enter (or Ctrl-Enter on
% Windows machines) you will run the section of code contained beneath the
% (%%) header and ONLY that section. This will come in handy in this
% tutorial and later in the semester.
% 
% The basic format for all assignment scripts is the following:
% 
% SECTION A: TITLE
% % *** comment describing purpose of first section
% --> 1. Inputs
% --> 2. Initialize all variables
% --> 3. setup all loops, using comments for subsections
% --> 4. declare figures for any plotting
% --> 5. Outputs
% 
% SECTION B: TITLE
% % *** comment describing purpose of section AND any sections that this
% % *** section depends on.
% --> 1. Inputs
% ... etc
% 
% SECTION C: TITLE
% ... etc
% 
% FINAL SECTION: TITLE
% % *** comment describing purpose of section AND any sections that this
% % *** section depends on.
% --> Any final plotting, output, saving etc.
% 
% In the assignments it will be pretty clear when sections should be
% created, which sections will depend on which, etc. 



%% Section 1: Variables, Data Types, Operations

% Here we'll do a quick review of what was in the MATLAB OnRamp tutorial,
% and supplement with some of what we think everyone should know about
% different data types in MATLAB. You can follow along with us or go at
% your own pace.




%% 1.1 Scalars

% For assignment, use the = operator, the ; suppresses output to the
% console. You can run a script without them, but it clutters up the
% command line interface. 
a = 10;



% scalar variables get all of the mathematical operators you can thing of:
% +, -, /, *, ..., can u think of anything else? What would the following
% line do?
b = a^2;



% what about this line?
c = b^(1/a);




% operations on scalars, and even more complicated data types like vectors
% and matrices, follows normal order of operations. BE CAREFUL THO: as we
% will see below, care is required to use some operations on higher order
% variable types. 

% MATLAB also supplies alot of nice in-house math functions that one can
% use on scalar variables. These include trig functions, nth-root, e^x, even more
% complicated things that require some more knowledge. So you can do things
% like:
x=0.54;
d = exp(sqrt(b^2 + x^2 - a/c)-sin(b/c));


% Parentheses determines order of operations

% *** NOTE: If you ever have a questions about what a function does, go to the
% command line and type 

% >> help [function]

% If [function] is a MATLAB function, there will be a nice help page
% displayed. If [function] one of your variables, it will display
% information about what is contained within the variable. 


%% 1.2 Vectors  

% This is a row vector
v1 = [1, 2, 3];



% This is a column vector
v2 = [1; 2; 3];



% Q: What if I wanted a vector that had all even integers from 2 to 1000 ? Use a semicolon for output suppression
u1 = ;%... 




% Matrix multiplication holds for vectors in MATLAB. So when we assign
a = v1*v2;
% we are actually performing the inner product (v1,v2) (which is also the
% vector dot product). If you have two vectors that are the same
% orientation and size, you can use the dot operator . with multiplication
% to do component-wise multiplication.
v3 = [5, 3, 1]; 
v4 = v1.*v3;




% Since this is component wise multiplication, b is set to a vector. It
% would be equivalent to write: b = [v1(1)*v2(1) + v1(2)*v2(2) + ...];





% You can also do component wise division using ./ (non-component-wise
% division of two vectors is not defined). Addition and Subtraction are
% always component-wise, so no need to use the dot. 
% HOWEVER, note what happens when one does this:
V = v1 + v2;
% What sort of object is V?





% *** NOTE: A good keyword that is created whenever you create a vector is
% "end"...which gives the final index of a vector. So, for example
b = v3(end);
% will put the value v1(3)*v2(3) into b.


%% 1.3 Matrices
% Just as vectors are collections of scalars with a set of operations,
% matrices are sets of vectors with a different, but related, set of
% operations. This is because in MATLAB (and indeed in Algebra) everything
% is an array (or tensor). So to construct an n x m matrix, you essentially
% just stack n m-component row vectors on top of one another (or, equivalently,
% lay m n-component column vectors side-by-side).
% 
% THIS MEANS that you can use alot of the same intuition from dealing with
% vectors when you are dealing with a matrix
% 
% Before this section, look up the following array-defining functions:
% zeros, ones, eye, magic


% Lets make a 3x3 matrix of 1's
M1 = ones(3,3);

% M(n,:) accesses the nth row, and M(:,m) accesses the mth column. 
% Q: How would you interchange a row for v1? A column for v2?




% The * operator is matrix-multiplication, which means that in order to use
% it, you need to have "conforming" matrices. That is, if we had
M2 = ones(3,4);
M3 = ones(5,8);
M4 = M2*M3;
% M4 will not be created, and M2*M3 will throw an error. How could you edit
% the above code to make M2*M3 work?





% Q: What would the .* operator be then? Generate 2 matrices of your
% choice, and put the product of both * and .* into a third matrix.






% By this point, we should probably tell you that . in front of many
% operations makes it operate component wise. This means that as long as
% you have 2 matrices of the same size, you can use . in front of virtually
% any mathematical operator and there will be component wise operations
% between them. For example,
Q1 = magic(4);
Q2 = 0.75*magic(4); % note that scalar-matrix multiplication is always component wise, so no dot needed, and ' takes a transpose
Q3 = Q1.^Q2;


% This is quite useful, and something you will all be taking advantage of
% this semester. This is how you can create mathematical functions (as
% opposed to MATLAB functions, which are discussed below).
x = 0:0.01:2;
y = x.^2;
% y now has all the values of the above values of x squared. If you wanted
% to plot this, you can use MATLAB's plot function:
plot(x,y);

% We'll discuss plotting functionality in later sections, but know that
% plot will always take in two arrays, one for x axis and the other for
% the y. If you are clever, passing in 2d arrays (matrices) instead of
% 1d arrays (vectors) will let you store information about multiple curves.

% *** NOTE: If you want to create higher-d arrays, you can. I'm not sure if
% MATLAB will let you create a 30-d array, but 3-d arrays (or matrices
% stacked in front of matrices) are common. For example,
Z1 = ones(3,3,3);
% will give you three 3x3 matrices of ones. 
% How would you edit this 3-d array to have one z-stack matrix become a
% 3x3 matrix of zeros?

%% 1.4 Vectorization...aka the best thing about MATLAB
% Now that we understand how to create n-d arrays, let's discuss some
% clever ways of accessing the data wihtin each object.

% BOOLEAN ASIDE: MATLAB comes with several BOOLEAN operations. They are
% essential for using control structures (like if statements and loops) but
% they can also be used to access certain array elements. One more new
% thing: rand(); This generates a nxmxo....xz array of random numbers uniformly
% distributed between between 0 and 1. Suppose
r1 = rand(100,1);

% The command
ind1 = r1 < 0.5;
% gives a vector of BOOLEAN variables (1 for true, 0 for false), as you can
% verify using >> help ind1 on the command line. 

% Q: What happens when you do r2 = r1(ind1)? 


% Vectorization, or the accessing of array indices using vectors (instead
% of control structures) is incredibly powerful. We'll point out potential
% places to implement vectorization in the tutorial and throughout the
% semester.

%% Section 2: Loops
% Now that we know the basic MATLAB containers (array), we can start to use
% Basic Control structures that are ubiquitous in any language. These
% include
% 
% "if" statements (also switches, which we wont talk about today)
% "while" Loops
% "for" Loops
% 
% If you have seen these before, skip ahead to section 2.1. If not, here's
% a quick intro:
% 
% if statements are set up like this...
% 
% if bool1
% 
%   <statements1>
% 
% elseif bool2
% 
%   <statements2>
% 
% elseif bool3
% 
%   .
%   .
%   .
% 
% elseif boolN
% 
%   <statementsN>
% 
% else  
% 
%   <statementsELSE>
% 
% end
% 
% If bool1 is true, <statements1> execute. If not, the first boolean
% variable booli for 2 < i < N will execute. If none of the boolean
% variables are true, then <statementsELSE> execute. You can setup a set
% of if statements including some or none of the elseif/else statements, as
% long as the statement ends with the keyword end. 
% 
% 
% 
% 
% 
% "while" and "for" loops are both similar to one another. They look like
% 
% while (bool)
% 
% 
% end
% 
% for index = vec
% 
% 
% 
% end
% 
% In a while loop, while will execute until the statement in the boolean
% variable is true. In the for loop, the scalar "index" will take on a
% value in the vector variable "vec" and can be used within the loop.
% 
% *** NOTE: While for loops will always end when "index" accesses vec(end),
% while loops have the capacity to never end (a so-called infinite loop).
% Its always good to have catches in your code that ensure that you never
% have an infinite loop.
% 


%% 2.1 For Loops
% Utilizing the following for loop, create a vector v2 that is identical to v1
v1=1:10;

% Initialize a vector, v2, of zeros of length 10:



% Write a for loop to fill in the vector



%% Check that the vectors are identical using boolean logic
% The "all" function asseses whether all entries are 1/true

disp(all(v1==v2))

%% 2.2 Structure of While Loops
% While loops have the same format of for loops with the
%   exception that the vector equlity is replaced with a conditional
%   so long as the conditional is true the loop will run
%   Here we have constructed a loop to simulate flipping a coin until 
%   the coin ends as tails.

% We initialize the coin as heads (1)
coin=1;
% We initialize a counter
cnt=0;
% Here our conditional is that the loop will continue so long as the coin is heads
while coin==1
     %  We generate a random number between 0 and 1 
     %  Then we round this value to give us tails (0) or heads (1)
    coin=round(rand(1));
    cnt=cnt+1; % increase counter
end 
cnt=cnt-1;  % The counter is decreased by 1 to give us the number of heads flips
disp(coin)  % check that the coin is tails (0)
disp(cnt)   % print to the sceen the number of flips


%% 2.3 All for loops can be written as while loops
% Write a while loop to create a vector v3 that is identical to v1 and v2










%% Section 3. Defining a Function
% Write a Function that calculates the mean, standard deviation, and median
% in the file VectorStatistics.m






%% Section 4. Plotting Histograms
% Now that we can define a function, we'll do a lil application of what
% we know so far: histogramming. Histograms are very important to
% understand in MATLAB, so we'll walk through some of the basics.



%% 4.1 Create a distribution to be plotted
% Here we will use the loop created earlier to generate a study of the 
% number of consecutive coin flips resulting in heads

% Initialize a vector of 1000 zeros to store the results of the trials

CoinCounts=zeros(1000,1);

for i=1:1000
    % We initialize the coin as heads (1)
    coin=1;
    % We initialize a counter
    cnt=0;
    % Here our conditional is that the loop will continue so long as the coin is heads
    while coin==1
         %  We generate a random number between 0 and 1 
         %  Then we round this value to give us tails (0) or heads (1)
        coin=round(rand(1));
        cnt=cnt+1; % increase counter
    end 
    cnt=cnt-1;  % The counter is decreased by 1 to give us the number of heads flips
    CoinCounts(i)=cnt; % Store result of trial in CoinCounts
end



%% 4.2 Calculate Statistics of Study
% Use the function VectorStatistics to calculate the mean, median, 
% standard deviation, and quartiles of the coin flip study



%% 4.3 Plot the Histogram of the Resultant Distribution (CoinCounts)
% First define we define a vector, bin_edges, of values to 
%  use as the bin edges for the histogram

bin_edges=-0.5:10.5;

% Create a figure handle and a new figure

f0=figure();

% Use the "histogram" function to plot a histogram of CoinCounts 
% using the bins defined by bin_edges. % Use the normalization choice pdf.
% This ensures that the histogram will be normalized such that the resultant
% plot will be that of the probability distribution function



% The probability distribution defining the number of failed trials 
% before the first success is known as the geometric distribution.
% Create a vector of the center of the bins named bin_centers.



% Calculate the theoretical distribution. The geometric distribution
% is defined as P(N) = p(1-p)^N, where p is the probability of a success 
% and N is the number of failed trials until the first successful one. 
% Create a vector named P_N, using "bin_centers" as your N.



% Use "hold" to plot the theoretical distribution on top of the histogram



% Add axis labels and a legend using "xlabel","ylabel", and "legend"



% Use the figure handle, "f0", and the functions "savefig" and "saveas" to 
% save your figure as a matlab figure (.fig) and an image file (.png) 




%% Section 5. Input/Output
% Inputting and Outputting data is probably the most important thing to do
% right as a science grad student, and fortunately MATLAB makes I/O super
% simple. If you've done the MATLAB OnRamp tutorial, you've seen the
% easiest form of MATLAB I/O in the form of save() and load() functions.
% 
% Basically, save() will store all of the variables in your
% workspace into a "matfile". If you want to access these variables, i.e.
% put them ~back~ into your work space, use load(<matfile>) and the
% variables have their same values.
% 
% However, not every piece of data will be stored in a nice matfile. Often
% times a colleague or collaborator or your annoying TAs will give you
% data in a .txt, .csv, .xlsx, .dat., .whatever file, and you will have to
% figure out how to deal with it. 
% 
% First piece of advice....see if matlab has a function that will handle
% the specific file (i.e. check >> help [function] for csvread, dlmread, textscan, importdata,etc)
% 
% Every data file will be different, and there are different tips and
% tricks for each one that we will go over throughout the semester. For
% now, we'll use the low level "textscan"

% textscan is clunky and a bit abstract, but it can read in basically
% anything you give it.

% 4.1 Use fopen to open the file in MATLAB, and put the file location into
% a variable fid.
fid = fopen('test_data_1.dat');

% 4.2 Use textscan to load in info from fid into cell container data_cell
% (we will talk about cells in class, they are a very nice container that
% can contain just about anything)
data_cell = textscan(fid, '%s%d%s%f%f%f', 'headerlines', 1);
% You can read through the >> help textscan document for more info, but the
% 'headerlines' char input tells textscan how many lines to skip before
% dealing with data

% 5.3 Lets get the position data...put columns 4 5 6 into 3 arrays for x, y and z positions








% 5.4 Now that we have the data, calculate the center of mass of all of
% these points. You can use a loop or, if you are intrepid, ~vectorize~.







% 5.5 Now lets make the origin the center of mass. Save these new, relative
% positions into three new column vectors. You can again use a loop of
% vectorization.






% 5.6 Use fclose to close MATLAB's connection to test_data_1.dat
fclose(fid);



% 5.7. Let's re-output the relative positions data into cmpos.dat. Open pos.data using
% fopen, but because we are creating a file, use the following form
fid = fopen('cmpos.data','w');



% 5.8. Look up info on the function fprintf, and then print out the data;
% You will need to concatanate relative position data into a single array,
% and then define the output format.





% 5.9. Close fid again
fclose(fid);

%% Section 6. The Central Limit Theorem

% seed our random number generator

% declare how many coins we want to flip

% how many flips per coin?

% Let's generate an array of random numbers, where rows signify flips, and
% columns are trials

% Map random numbers between 0 and 1 to 0's or 1's (hint: use round(...))

% To get outcome, we can just sum up all independent flips (hint: use
% sum(...))

% Plot a histogram of the outcomes








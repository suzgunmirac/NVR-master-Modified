function [M, differenceMatrixH, differenceMatrixN] = NVR_SHIFTX2PROB(TABLE,...
						  H,N,TYPES,SSTRUCT,NOES,...
						  ALLDISTS, ...
						  NTH,ROWIN,COLIN, ...
						  SHIFTX_Filename,...
						  truncateProbabilities);

FILTERS=load('CHEMSHIFTSTATS/SHIFTXFILTERS');FILTERS=FILTERS.FILTERS;

[rn TY SS ha hn nf cb ca co]= textread(SHIFTX_Filename,'%f %s %s %f %f %f %f %f %f');

PRED = [rn  hn nf];

%get the scores for the two predictions
M=TABLE*0+1/size(TABLE,1);

differenceMatrixH = zeros(size(M,1),size(M,2));
differenceMatrixN = zeros(size(M,1),size(M,2));

for(i=1:size(TABLE,1))
   for(j=1:length(COLIN))

     
     if (i == j)
       printDetails = 1;
     else
       printDetails = 0;
     end
     
      T = TY(COLIN(j));
      S = SS(COLIN(j));
      
      h = H(i)-PRED(COLIN(j),2);
      n = N(i)-PRED(COLIN(j),3);
      
      differenceMatrixH(i,j) = 1/(1+exp(abs(h)));
      differenceMatrixN(i,j) = 1/(1+exp(abs(n)));
      
      if(strcmp(T,'A')==1)
         M(i,j)=getProb(h,n, S,FILTERS,1,truncateProbabilities,printDetails);
      elseif(strcmp(T,'C')==1)
         M(i,j)=getProb(h,n,S,FILTERS,2,truncateProbabilities,printDetails);
      elseif(strcmp(T,'D')==1)
         M(i,j)=getProb(h,n,S,FILTERS,3,truncateProbabilities,printDetails);
      elseif(strcmp(T,'E')==1)
         M(i,j)=getProb(h,n,S,FILTERS,4,truncateProbabilities,printDetails);
      elseif(strcmp(T,'F')==1)
         M(i,j)=getProb(h,n,S,FILTERS,5,truncateProbabilities,printDetails);
      elseif(strcmp(T,'G')==1)
         M(i,j)=getProb(h,n,S,FILTERS,6,truncateProbabilities,printDetails);
      elseif(strcmp(T,'H')==1)
         M(i,j)=getProb(h,n,S,FILTERS,7,truncateProbabilities,printDetails);
      elseif(strcmp(T,'I')==1)
         M(i,j)=getProb(h,n,S,FILTERS,8,truncateProbabilities,printDetails);
      elseif(strcmp(T,'K')==1)
         M(i,j)=getProb(h,n,S,FILTERS,9,truncateProbabilities,printDetails);
      elseif(strcmp(T,'L')==1)
         M(i,j)=getProb(h,n,S,FILTERS,10,truncateProbabilities,printDetails);
      elseif(strcmp(T,'M')==1)
         M(i,j)=getProb(h,n,S,FILTERS,11,truncateProbabilities,printDetails);
      elseif(strcmp(T,'N')==1)
         M(i,j)=getProb(h,n,S,FILTERS,12,truncateProbabilities,printDetails);
      elseif(strcmp(T,'Q')==1)
         M(i,j)=getProb(h,n,S,FILTERS,14,truncateProbabilities,printDetails);
      elseif(strcmp(T,'R')==1)
         M(i,j)=getProb(h,n,S,FILTERS,15,truncateProbabilities,printDetails);
      elseif(strcmp(T,'S')==1)
         M(i,j)=getProb(h,n,S,FILTERS,16,truncateProbabilities,printDetails);
      elseif(strcmp(T,'T')==1)
         M(i,j)=getProb(h,n,S,FILTERS,17,truncateProbabilities,printDetails);
      elseif(strcmp(T,'V')==1)
         M(i,j)=getProb(h,n,S,FILTERS,18,truncateProbabilities,printDetails);
      elseif(strcmp(T,'W')==1)
         M(i,j)=getProb(h,n,S,FILTERS,19,truncateProbabilities,printDetails);
      elseif(strcmp(T,'Y')==1)
         M(i,j)=getProb(h,n,S,FILTERS,20,truncateProbabilities,printDetails);
      else
         PROBLEM = TYPES(COLIN(j))   
      end
   end

   if (sum(M(i,:)) == 0)
   %  keyboard
     M(i,:) = 1/size(M,2);
   else
     M(i,:) = M(i,:)/sum(M(i,:));%re-normalize
   end
end

M = M .* TABLE;
%renornmalize
for(i=1:size(M,1))
   if(sum(M(i,:))==0)
      M(i,:)=1;
%     fprintf(1, 'shiftx bpg construction removed all entries from row #%d',i);
   end
%   else
   M(i,:)=M(i,:)/sum(M(i,:));
   %   end
end


function p = getProb(h,n,SSTYPE,FILTERS,TY, truncateProbabilities,printDetails)%

persistent maxCoeff1 maxCoeff2 maxCoeff3 maxCoeff4;
persistent firstCall coeff1_ExtraMultiplier coeff2_ExtraMultiplier;
persistent coeff3_ExtraMultiplier coeff4_ExtraMultiplier;

if (isempty(maxCoeff1))
  maxCoeff1 = 1;
end
if (isempty(maxCoeff2))
  maxCoeff2 = 1;
end
if (isempty(maxCoeff3))
  maxCoeff3 = 1;
%  fprintf(1, 'warning. multiplying maxCoeff3 with 3.90 for poln.\n');
end
if (isempty(maxCoeff4))
  maxCoeff4 = 1;
end



%if (isempty(firstCall))
%   fprintf(1, 'will increase maxCoefficients for MBP.\n');
%   firstCall              = 1;
%   coeff1_ExtraMultiplier = 14.12;
%   coeff2_ExtraMultiplier = 115.09;
%   coeff3_ExtraMultiplier = 2.42;
%   coeff4_ExtraMultiplier = 2.25;
%end

%if (isempty(firstCall))
%  fprintf(1, 'will increase maxCoefficients for EIN.\n');
%  firstCall              = 1;
%  coeff1_ExtraMultiplier = 9.13;
%  coeff2_ExtraMultiplier = 1.96;
%  coeff3_ExtraMultiplier = 1;
%  coeff4_ExtraMultiplier = 2.52;
%end
%

% $$$ if (isempty(firstCall))
% $$$   fprintf(1, 'will increase maxCoefficients for CAM2.\n');
% $$$   firstCall              = 1;
% $$$   coeff4_ExtraMultiplier = 1.04;
% $$$ end

if(strcmp(SSTYPE,'C')==1)
   
   xH = FILTERS(3,TY,1,1);
   xHS = FILTERS(3,TY,1,2);
   xN = FILTERS(3,TY,2,1);
   xNS = FILTERS(3,TY,2,2);
   xHMX = FILTERS(3,TY,1,4);
   xHMN = FILTERS(3,TY,1,3);
   xNMX = FILTERS(3,TY,2,4);
   xNMN = FILTERS(3,TY,2,3);
   
elseif(strcmp(SSTYPE,'B')==1)
   
   xH = FILTERS(2,TY,1,1);
   xHS = FILTERS(2,TY,1,2);
   xN = FILTERS(2,TY,2,1);
   xNS = FILTERS(2,TY,2,2);
   xHMX = FILTERS(2,TY,1,4);
   xHMN = FILTERS(2,TY,1,3);
   xNMX = FILTERS(2,TY,2,4);
   xNMN = FILTERS(2,TY,2,3);
   
else
   xH = FILTERS(1,TY,1,1);
   xHS = FILTERS(1,TY,1,2);
   xN = FILTERS(1,TY,2,1);
   xNS = FILTERS(1,TY,2,2);
   xHMX = FILTERS(1,TY,1,4);
   xHMN = FILTERS(1,TY,1,3);
   xNMX = FILTERS(1,TY,2,4);
   xNMN = FILTERS(1,TY,2,3);
   
end

%fprintf(1, 'computing probability.\n');
%keyboard

%correction factor

%xHMX=xHMX*1.2*3.0*coeff1_ExtraMultiplier;
%xHMN =xHMN *1.2*2.2*coeff2_ExtraMultiplier;
%xNMX =xNMX *1.2*6.4*coeff3_ExtraMultiplier;
%%xNMX =xNMX *1.2*6.4*3.90;
%xNMN =xNMN *1.2*1.7*coeff4_ExtraMultiplier;

xHMX=xHMX  *1.2*3.0;
xHMN =xHMN *1.2*2.2;
xNMX =xNMX *1.2*6.4;
% $$$ %xNMX =xNMX *1.2*6.4*3.90;
xNMN =xNMN *1.2*1.7;


%xHMX=xHMX*1.2;
%xHMN =xHMN *1.2;
%xNMX =xNMX *1.2;
%xNMN =xNMN *1.2;

%fprintf(1, 'changed the truncation back to original.\n');
%keyboard

if (truncateProbabilities)
 if(h>xH)
    if((h-xH)/xHS > xHMX)
      
       if (printDetails == 1)
       %fprintf(1, 'h: numStandardDeviationsAway : %f Limit : %f\n',(h-xH)/xHS,xHMX);
       fprintf(1, 'Ratio : %f\n',(h-xH)/xHS/xHMX);
       coeff1 = (h-xH)/xHS/xHMX;
       if (isempty(maxCoeff1))
	 maxCoeff1 = coeff1
       elseif (coeff1 > maxCoeff1)
	 maxCoeff1 = coeff1
       end
     end
       p=0;
       p1 = 0;%return
    else
       p1=normpdf(h,0,xHS);
    end
 else
    if((xH-h)/xHS > xHMN)
      if (printDetails == 1)
	%	fprintf(1, 'h: numStandardDeviationsAway : %f Limit :
	%	%f\n',-(h-xH)/xHS,xHMN);
	fprintf(1, 'Ratio : %f\n',-(h-xH)/xHS/xHMN);
      
	coeff2 = -(h-xH)/xHS/xHMN;
	if (isempty(maxCoeff2))
	  maxCoeff2 = coeff2
	elseif (coeff2 > maxCoeff2)
	  maxCoeff2 = coeff2
	end
      end
       p=0;
       p1=0;%return
    else
       p1=normpdf(h,0,xHS);
    end
 end
 if(n>xN)
    if((n-xN)/xNS > xNMX)
       if (printDetails == 1)
	%	fprintf(1, 'h: numStandardDeviationsAway : %f Limit : %f\n',(n-xN)/xNS,xNMX);
        fprintf(1, 'Ratio : %f\n',(n-xN)/xNS/xNMX);
	
	coeff3 = (n-xN)/xNS/xNMX;
	if (isempty(maxCoeff3))
	  maxCoeff3 = coeff3
	elseif (coeff3 > maxCoeff3)
	  maxCoeff3 = coeff3
	end
      end
      
       p=0;
       p2 = 0;
       %return
    else
       p2=normpdf(n,0,xNS);
    end
 else
    if((xN-n)/xNS > xNMN)
      if (printDetails == 1)
	%	fprintf(1, 'h: numStandardDeviationsAway : %f Limit : %f\n',-(n-xN)/xNS,xNMN);
        fprintf(1, 'Ratio : %f\n',-(n-xN)/xNS/xNMN);
	
	coeff4 = -(n-xN)/xNS/xNMN;
	if (isempty(maxCoeff4))
	  maxCoeff4 = coeff4
	elseif (coeff4 > maxCoeff4)
	  maxCoeff4 = coeff4
	end
      end
      p=0;
      p2 = 0;
      %return
    else
       p2=normpdf(n,0,xNS);
    end
  end

%input('d');
else
  p1=normpdf(h,0,xHS);
  p2=normpdf(n,0,xNS);
end
p = p1*p2;

if ((p == 0) & (printDetails == 1))
  fid = fopen('maxCoefficients_SHIFTX.txt','w');
  fprintf(1, 'check out maxCoefficients_SHIFTX.txt\n');
  fprintf(fid, '%f %f %f %f\n', maxCoeff1,maxCoeff2,maxCoeff3,maxCoeff4);
  fclose(fid);
end


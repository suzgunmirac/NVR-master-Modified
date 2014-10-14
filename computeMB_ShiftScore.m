function [M, numCS] = computeMB_ShiftScore(TABLE,H,N, SHIFTS_Filename)

%: This computes assignment probabilities based on the program SHIFTS, it is not meant
%             to be called by the user


%////////////////////////////////////////////////////////////////////////////////////////////
%//  HD_SHIFTS2PROB.m
%//
%//  Version:		0.1
%//
%//  Description:	 This computes assignment probabilities based on on the program SHIFTS
%//
%// authors:
%//    initials    name            organization 					email
%//   ---------   --------------  ------------------------    ------------------------------
%//     CJL         Chris Langmead  Dartmouth College         langmead@dartmouth.edu
%//
%//
%// history:
%//     when        who     what
%//     --------    ----    ----------------------------------------------------------
%//     12/02/03    CJL 	 initial version for publication [Langmead et al, J Biomol NMR 2004]
%//
%////////////////////////////////////////////////////////////////////////////////////////////

%    HD_SHIFTS2PROB
%    This library is free software; you can redistribute it and/or
%    modify it under the terms of the GNU Lesser General Public
%    License as published by the Free Software Foundation; either
%    version 2.1 of the License, or (at your option) any later version.

%    This library is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%    Lesser General Public License for more details.

%    You should have received a copy of the GNU Lesser General Public
%    License along with this library; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% 		Contact Info:
%							Bruce Randall Donald
%							HB 6211
%							Dartmouth College
%							Hanover, NH 03755
%							brd@cs.dartmouth.edu

% 		If you use publish any results derived from the use of this program please cite:
%		"An Expectation/Maximization Nuclear Vector Replacement Algorithm for Automated NMR Resonance Assignments," 
%		C. J. Langmead and B. R. Donald, 
%		Journal of Biomolecular NMR, 2004 (in press)


%  Copyright (C) 2003  Christopher James Langmead and Bruce R. Donald
%
%  <signature of Bruce Donald>, 2 December 2003
%  Bruce Donald, Professor of Computer Science

%FILTERS=load('/home/home4/apaydin/Mist/NVR/CHEMSHIFTSTATS/SHIFTSFILTERS');FILTERS=FILTERS.FILTERS;

%[rn TY SS ha hn nf cb ca co]= textread(SHIFTX_Filename,'%f %s %s %f %f %f %f %f %f ');

[rn hn nf]= textread(SHIFTS_Filename,'%f %f %f ');

PRED = [rn  hn nf];

numCS = size(TABLE,1) * 2;
%size(PRED)

%get the scores for the two predictions
M=TABLE*0;%+1/size(TABLE,1);

for(i=1:size(TABLE,1))
   for(j=1:length(rn))
      
%T = TY(j);
%S = SS(j);
      
      h = abs(H(i)-PRED(j,2));
      n = abs(N(i)-PRED(j,3));
      
      if (h < 0.25) 
	M(i,j) = M(i,j) + 1;
      elseif (h < 1)
	M(i,j) = M(i,j) + (-4/3)*(h - 1);
      end
      
      if (n < 2.5)
	M(i,j) = M(i,j) + 1;
      elseif (n < 10)
	M(i,j) = M(i,j) + (-1/7.5)*(n - 10);
      end
%      keyboard
   end
end

M = M .* TABLE;






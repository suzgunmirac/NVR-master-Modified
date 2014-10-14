function prunedPossibleAssignmentsBPG = NOE_PRUNE(possibleAssignmentsBPG,NOES,ALLDISTS,NTH, ROWIN,COLIN);


%NVR_NOE2PROB: This computes assignment probabilities based on NOES


%////////////////////////////////////////////////////////////////////////////////////////////
%//  NVR_NOE2PROB.m
%//
%//  Version:		0.1
%//
%//  Description:	 This computes assignment probabilities based on noes
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

%    NVR_NOE2PROB
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

prunedPossibleAssignmentsBPG=and(possibleAssignmentsBPG,possibleAssignmentsBPG);

for(relPeakIndex=1:size(possibleAssignmentsBPG,1))

  absolutePeakIndicesOfPeaksHavingAnNOEWithPeak_relPeakIndex = find(NOES(ROWIN(relPeakIndex),:));%set of peaks having an noe with this one
  
  if(length(absolutePeakIndicesOfPeaksHavingAnNOEWithPeak_relPeakIndex)>0 )      %if (peak # relPeakIndex has NOE constraints)
     %NOES(ROWIN(relPeakIndex),:) refers
     %to the NOES peak #relPeakIndex has.
          
     possibleAbsoluteResidueIndicesForPeak_RelPeakIndex = COLIN(find(possibleAssignmentsBPG(relPeakIndex,:))); %find out who it is could be
          
     if (isempty(possibleAbsoluteResidueIndicesForPeak_RelPeakIndex))
       fprintf(1, 'error. %dth peak is not assignable to anything here\n',relPeakIndex);
%       keyboard %MSA
     end

      for(j=1:length(absolutePeakIndicesOfPeaksHavingAnNOEWithPeak_relPeakIndex)) 
	%go through all NOE peaks with peak relPeakIndex

	relPeakIndexHavingNOEWithPeak_relPeakIndex=find(ROWIN==absolutePeakIndicesOfPeaksHavingAnNOEWithPeak_relPeakIndex(j));

%previously it may have been possible not to find the peak having
%an NOE with peak relPeakIndex, since that peak could have been
%assigned. In that case the old HD did not make use of that
%information. This allowed not to make incorrect pruning in case
%previous assignment was incorrect, but also did not take advantage
%of extra data, in case the previous assignment was correct.
	
	
	if(length(relPeakIndexHavingNOEWithPeak_relPeakIndex)>0)
	  %if peak with relative index
	  %relPeakIndexHavingNOEWithPeak_relPeakIndex is assigned, then it
	  %may be possible not to find its index in ROWIN.
	  %            szin=length(find(M(relPeakIndexHavingNOEWithPeak_relPeakIndex,:)));
	  
	  for(relResidueIndex=1:size(possibleAssignmentsBPG,2))
	    
	    absoluteResidueIndex = COLIN(relResidueIndex);
	    
	    distOfRes_AbsResIdxToPotOfPk_RelPkIdx = ALLDISTS(possibleAbsoluteResidueIndicesForPeak_RelPeakIndex,absoluteResidueIndex);
	    
	    if(min(distOfRes_AbsResIdxToPotOfPk_RelPkIdx)>NTH)
	      %if residue # absoluteResidueIndex is too far away from potential
	      %assignments to peak # relPeakIndex...
	      
	      prunedPossibleAssignmentsBPG(relPeakIndexHavingNOEWithPeak_relPeakIndex,relResidueIndex)=0;
	      
	    end
	    
	    if(length(find(prunedPossibleAssignmentsBPG(relPeakIndexHavingNOEWithPeak_relPeakIndex,:)))==0)
%if all the possible assignments for peak #
%relPeakIndexHavingNOEWithPeak_relPeakIndex are removed, then
%restore back the possible assignments for peak #relPeakIndexHavingNOEWithPeak_relPeakIndex.
	      
	      prunedPossibleAssignmentsBPG(relPeakIndexHavingNOEWithPeak_relPeakIndex,:)=possibleAssignmentsBPG(relPeakIndexHavingNOEWithPeak_relPeakIndex,:);
	    end
	  end
	  %            szout=length(find(M(relPeakIndexHavingNOEWithPeak_relPeakIndex,:)));
	end
      end
  end
end



for(relPeakIndex=1:size(possibleAssignmentsBPG,1))
   if(length(find(prunedPossibleAssignmentsBPG(relPeakIndex,:)))==0)
      prunedPossibleAssignmentsBPG(relPeakIndex,:)=possibleAssignmentsBPG(relPeakIndex,:);
   end
end

dbstop if error
dbstop if warning

  
  
  
if (~exist('ROWIN'))

  [ROWIN, COLIN, ASSIGNTABLE, MASTER, HDE,  CP, SXCP, SSCP, NTH, RP1, RP2,differenceMatrixH_SHIFTX, differenceMatrixN_SHIFTX, differenceMatrixH_SHIFTS, differenceMatrixN_SHIFTS,alphaHelixMatrix,betaStrandMatrix,coilMatrix] = initialize_withCH(peaks,HDEXCHANGE, ...
						  peakIDs, NOES, ...
						  VECTORS_NH, VECTORS_CH,TYPES, ...
						  RESNUMS,SSTRUCT, ...
						  HBOND, ALLDISTS,IALLDISTS, SHIFTS_Filename, SHIFTX_Filename, NH_RDCS, CH_RDCS);

  nlast = sum(sum(ASSIGNTABLE));
for(i=1:100)
  [MASTER,ASSIGNTABLE]=updateMASTER(MASTER,ASSIGNTABLE,ROWIN,COLIN);[ROWIN,COLIN]=sanitycheck(MASTER,ROWIN,COLIN);
  [ASSIGNTABLE,CP,SXCP,SSCP,RP1,RP2,ROWIN,COLIN]=reduceAll(ASSIGNTABLE,CP,SXCP,SSCP,RP1,RP2,ROWIN,COLIN);[ROWIN,COLIN]=sanitycheck(MASTER,ROWIN,COLIN);
% $$$   [ASSIGNTABLE] = lockdown(MASTER,ASSIGNTABLE,NOES,ALLDISTS, NTH,ROWIN,COLIN);
% $$$   [MASTER,ASSIGNTABLE]=updateMASTER(MASTER,ASSIGNTABLE,ROWIN,COLIN);[ROWIN,COLIN]=sanitycheck(MASTER,ROWIN,COLIN);
% $$$   [ASSIGNTABLE,CP,SXCP,SSCP,RP1,RP2,ROWIN,COLIN]=reduceAll(ASSIGNTABLE,CP,SXCP,SSCP,RP1,RP2,ROWIN,COLIN);[ROWIN,COLIN]=sanitycheck(MASTER,ROWIN,COLIN);
  if(sum(sum(ASSIGNTABLE)) == nlast)
    break;
  end
  nlast = sum(sum(ASSIGNTABLE));
end

  
fprintf(1, 'assigned first %d residues. These are:\n', ...
	sum(sum(MASTER)));
for i = 1:size(MASTER,1)
  v = find(MASTER(i,:));
  if isempty(v)
    continue;
  end
  for j = 1:length(v)
    fprintf(1, '%d %d\n', i, v(j));
  end
end
  
keyboard  

  if (1)
    
    myMASTER = MASTER*0;
    numPeaks = size(myMASTER,1);
  
    for peakIndex = 1:numPeaks
      myMASTER(peakIndex,peakIndex) = 1;
    end
    
    S1                               = updateTen_CH(myMASTER, ...
						    NH_RDCS,CH_RDCS, VECTORS_NH, VECTORS_CH);
%    S2                               = updateTen(myMASTER,RDC2,VECTORS);
    [RP1,differenceMatrix_RDC1]                              = NVR_RDC2PROB(ASSIGNTABLE,NH_RDCS,VECTORS_NH,S1,ROWIN,COLIN);
    [RP2,differenceMatrix_RDC2]                              = NVR_RDC2PROB(ASSIGNTABLE,CH_RDCS,VECTORS_CH,S1,ROWIN,COLIN);
    
    labelFilename   = '1ubi_Labels.txt';
    vectorsFilename = '1ubi_VectorsWithExtraColumnForMissingEntries.txt';
    
    printSVM_Information(MASTER,ASSIGNTABLE, ROWIN, COLIN,differenceMatrixH_SHIFTX, ...
			 differenceMatrixN_SHIFTX, differenceMatrixH_SHIFTS, ...
			 differenceMatrixN_SHIFTS,differenceMatrix_RDC1,differenceMatrix_RDC2, alphaHelixMatrix,betaStrandMatrix,coilMatrix,labelFilename, vectorsFilename);
    

    fprintf(1, 'printed files %s and %s\n', labelFilename, vectorsFilename);
    keyboard
%     save ('allPeaksAssignmentEnvironment-ForFF2-forBayesianScoring-withNVR_ScoringMatrices-CH_RDCs-simpleInitialize.mat');
     
%     fprintf(1, 'saved allPeaksAssignmentEnvironment-ForFF2-forBayesianScoring-withNVR_ScoringMatrices-CH_RDCs-simpleInitialize.mat\n');

     save ('allPeaksAssignmentEnvironment-ForFF2-forBayesianScoring-withNVR_ScoringMatrices-CH_RDCs-simpleInitialize.mat');
     
     fprintf(1, 'saved allPeaksAssignmentEnvironment-ForFF2-forBayesianScoring-withNVR_ScoringMatrices-CH_RDCs-simpleInitialize.mat\n');

 
    keyboard
  end
  
  origCP = CP; origSXCP = SXCP; origSSCP= SSCP; origHDE ...
	   = HDE; origROWIN = ROWIN; origCOLIN = COLIN;
  [MASTER, ASSIGNTABLE, CP, SXCP, SSCP,  HDE, ROWIN, COLIN]= ...
      AssignFirstFiveResidues_withCH(MASTER, ASSIGNTABLE, NOES, IALLDISTS, ...
			      NTH, ROWIN, COLIN, ALLDISTS, CP, SXCP, ...
			      SSCP, RP1, RP2, HDE, S1, NH_RDCS, ...
			      CH_RDCS, VECTORS_NH, VECTORS_CH);

  relRowIndices = []; relColIndices = [];
  for (rowinIndex=1:length(ROWIN))
    relRowIndices = [relRowIndices find(origROWIN == ROWIN(rowinIndex))];
  end
  
  for (colinIndex=1:length(COLIN))
    relColIndices = [relColIndices find(origCOLIN == COLIN(colinIndex))];
  end
  
  
  CP   = origCP(relRowIndices,relColIndices); 
  SXCP = origSXCP(relRowIndices,relColIndices); 
  SSCP = origSSCP (relRowIndices, relColIndices); 
  HDE  = origHDE(relRowIndices, relColIndices); 

   save allPeaksAfterInitialAssignments--For1UBI-WithNVR_Matrices-CH_RDCs-simpleInitialize.mat
   fprintf(1, 'saved the environment to allPeaksAfterInitialAssignments--For1UBI-WithNVR_Matrices-CH_RDCs-simpleInitialize.mat\n');


keyboard
end





fprintf(1, 'assigned first %d residues. These are:\n', ...
	sum(sum(MASTER)));
for i = 1:size(MASTER,1)
  v = find(MASTER(i,:));
  if isempty(v)
    continue;
  end
  for j = 1:length(v)
    fprintf(1, '%d %d\n', i, v(j));
  end
end








[totalNumPeaks,totalNumResidues] = size(MASTER);
numAssignedPeaks                 = 0;
numUnassignedPeaks               = totalNumPeaks;

numNvrVoters                     = 5;
%numVoters                        = 5;
notCompletedAssignments          = 1;
prevNumAssignedPeaks             = sum(sum(MASTER));

fullMASTER = MASTER*0;
for peakIndex = 1:size(MASTER,1)
  fullMASTER(peakIndex,peakIndex) = 1;
  assert (sum(fullMASTER(peakIndex,:)) == 1);
end

S1_full                                       = updateTen_CH(fullMASTER, ...
						  NH_RDCS, CH_RDCS, VECTORS_NH, ...
						  VECTORS_CH);

% $$$ S2_full                                       = updateTen(fullMASTER, ...
% $$$ 						  RDC2, VECTORS);

percentiles1 = []; percentiles2= [];
numCorrectPerIter   = []; numTotalAssignmentsPerIter = [];
initialMASTER = MASTER;   
initialASSIGNTABLE = ASSIGNTABLE;
initialROWIN = ROWIN;
initialCOLIN = COLIN;
initialSSCP = SSCP;
initialSXCP = SXCP;
initialCP = CP;
initialHDE = HDE; 
secondRun = 0;

%load alignmentTensorsAfterOneRoundOfCompleteAssignments.mat
  
S1                               = updateTen_CH(MASTER,NH_RDCS,CH_RDCS, VECTORS_NH, ...
						VECTORS_CH);



while (notCompletedAssignments)

  

  
  RP1                              = NVR_RDC2PROB(ASSIGNTABLE,NH_RDCS,VECTORS_NH,S1,ROWIN,COLIN);
  RP2                              = NVR_RDC2PROB(ASSIGNTABLE,CH_RDCS,VECTORS_CH,S1,ROWIN,COLIN);

  percentile1                               = ...
      NVR_COMP_TEN(S1,S1_full);
  
  fprintf(1, 'the percentile difference between the partial and full');
  fprintf(1, ' is %f\n', percentile1);

  percentiles1 = [percentiles1 percentile1];

  keyboard
  
  %change in variable names:
  peakIndices                      = ROWIN;
  residueIndices                   = COLIN;
  nvrVoter                         = initialize5Voters(SSCP,SXCP,CP,RP1, RP2);

  save originalVoters.mat SSCP SXCP CP RP1 RP2

  bayesianMatrix = computeBayesianMatrix_CH(ASSIGNTABLE, ROWIN, COLIN, ...
  					 nvrVoter, numNvrVoters);

  
%  [ASSIGNTABLE, impossibleToAssign] = noePrune(fullMASTER,ASSIGNTABLE,NOES,ALLDISTS, NTH,[],[]);

  [NP,impossibleToAssign]            = NVR_NOE2PROB (fullMASTER,NOES,ALLDISTS,NTH, [1:size(MASTER,1)],[1:size(MASTER,2)]);
  
  differenceMatrix = fullMASTER - NP;
  [differentPeakIndices,differentResidueIndices] = find(differenceMatrix);
  assert (isempty(differentPeakIndices));
  
  assert (impossibleToAssign == 0);
  
  fprintf(1, 'noe pruning passed on MASTER.\n');
   keyboard
   
   numVoters      = 1;
   voter          = cell(numVoters,1);
   voter{1}       = bayesianMatrix;
  DO_INDIVIDUAL_PIECE_MANUALLY = 0; DO_MANUAL_MERGING = 0; 
  STOCHASTIC_SEARCH      = 0;
  
  %individual pieces done here
  if (DO_INDIVIDUAL_PIECE_MANUALLY)
    doIndividualPieceManually(MASTER, voter, numVoters, ASSIGNTABLE, peakIndices, ...
			      residueIndices, NOES, ALLDISTS, IALLDISTS, NTH, ...
			      peakIDs, RESNUMS, RDC1, RDC2, VECTORS, MB_ShiftScore, ...
			      MB_RDC_Score, numCS, numRDC, HSQCDATA, csCoefficient, rdcCoefficient, noeCoefficient,numHN_NOES);
    
    keyboard
    
  elseif (DO_MANUAL_MERGING)
    %merging done here
    
    
    doMergingManually(peakIndices, ...
		      residueIndices, voter,numVoters,ASSIGNTABLE,NOES,ALLDISTS,IALLDISTS,NTH,peakIDs,RESNUMS,RDC1,RDC2,VECTORS, MB_ShiftScore, ...
		      MB_RDC_Score, numCS, numRDC, HSQCDATA, csCoefficient, rdcCoefficient, noeCoefficient,numHN_NOES);
    keyboard
  elseif (STOCHASTIC_SEARCH)
    stochasticSearch;
  else
    MB_ShiftScore = []; MB_RDC_Score = [];numCS = 0; numRDC = ...
	0;csCoefficient = 0; rdcCoefficient = 0; noeCoefficient = ...
	0; numHN_NOES = 0;
    [foundMASTERs, finalScores, assignmentAccuracies, totalNumAssignments]=divideAndConquer(MASTER, voter, numVoters, ASSIGNTABLE, peakIndices, ...
						  residueIndices, NOES, ALLDISTS, IALLDISTS, NTH, ...
						  peakIDs, RESNUMS, NH_RDCS, CH_RDCS, VECTORS_NH, ...%VECTORS_CH, 
						  MB_ShiftScore, ...
						  MB_RDC_Score, numCS, numRDC, HSQCDATA,csCoefficient, ...
						  rdcCoefficient, ...
						  noeCoefficient,numHN_NOES);
    
  end
  %manual running code ends.
  
  fprintf(1, 'finished divide and conquer\n');
  overallMASTER = zeros(totalNumPeaks, totalNumResidues);
  for i = 1:totalNumAssignments
    overallMASTER = overallMASTER + foundMASTERs{i};
  end
  
  if (totalNumAssignments > 0)
    aggregateMASTER = findAggregateMASTER(overallMASTER, ...
					  totalNumAssignments);
  else
    aggregateMASTER = MASTER;
  end
  
  
  %computeAssignmentAccuracy(peakIDs, RESNUMS, aggregateMASTER,1);
  numCorrect = 0; numAssignedPeaks = 0;
  for peakIndex = 1:size(aggregateMASTER,1)
    residueIndex = find(aggregateMASTER(peakIndex,:));
    assert (length(residueIndex) <= 1);
    if (peakIndex == residueIndex)
      numCorrect = numCorrect + 1;
    end
    if (~isempty(residueIndex))
      numAssignedPeaks = numAssignedPeaks + 1;
    end
  end
  
  fprintf(1, 'the aggregate assignment has %d correct out of %d positions.\n',numCorrect, numAssignedPeaks);
  
  numCorrectPerIter = [numCorrectPerIter numCorrect];
  numTotalAssignmentsPerIter = [numTotalAssignmentsPerIter numAssignedPeaks];
  

  MASTER = aggregateMASTER;

  if (secondRun == 1)
  else
    S1                               = updateTen_CH(MASTER,NH_RDCS, ...
						    CH_RDCS, VECTORS_NH, ...
						    VECTORS_CH);
  end
    
  numAssignedPeaks = sum(sum(aggregateMASTER));
  if ((numAssignedPeaks == prevNumAssignedPeaks) | (sum(sum(MASTER)) ...
						    == totalNumPeaks))
    if (secondRun == 1)
      break;
    else
      secondRun = 1;
      MASTER    = initialMASTER;
      prevNumAssignedPeaks = sum(sum(initialMASTER));
      ASSIGNTABLE = initialASSIGNTABLE;
      ROWIN = initialROWIN;
      COLIN = initialCOLIN;
      SSCP = initialSSCP;
      SXCP = initialSXCP;
      CP = initialCP;
      HDE = initialHDE; 
      save alignmentTensorsAfterOneRoundOfCompleteAssignments_CH.mat ...
	  S1 S1_full;
      continue;
    end
  else
    prevNumAssignedPeaks = numAssignedPeaks;
  end


  fprintf(1, 'will try to remove assigned peaks and residues.\n');
  keyboard
  if (sum(sum(MASTER)) ~= totalNumPeaks)
    

    
    [ASSIGNTABLE, voter, numVoters, ROWIN, COLIN,SSCP,SXCP,CP] = removeAssignedPeaksAndResidues_CH(MASTER, ASSIGNTABLE, voter, numVoters,peakIndices,residueIndices,SSCP,SXCP,CP);
  
  elseif (secondRun == 1)
    notCompletedAssignments  = 0;
  end
end

figure; 
plot(1:length(percentiles1), percentiles1*100, '*-', ...
     1: length(percentiles1),numCorrectPerIter, 'kx-', 1:length(percentiles1), numTotalAssignmentsPerIter, 'g^-',1:length(percentiles1),100*numCorrectPerIter./numTotalAssignmentsPerIter,'cv-');
grid
legend('MTC',  'numCorrectAssignments', ...
       'numTotalAssignments','assignment accuracy','Location','BestOutside');




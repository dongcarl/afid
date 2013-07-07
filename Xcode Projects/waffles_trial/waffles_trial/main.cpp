//
//  main.cpp
//  waffles_trial
//
//  Created by Carl Dong on 7/7/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#include <GClasses/GMatrix.h>
#include <GClasses/GHolders.h>
#include <GClasses/GRand.h>
#include <GClasses/GDecisionTree.h>
#include <iostream>

using namespace GClasses;
using std::cout;

int main(int argc, char *argv[])
{
	GMatrix* pData = GMatrix::loadArff("/Users/dongcarl/Downloads/mydata.arff");
	Holder<GMatrix> hData(pData);
	GMatrix* pFeatures = pData->cloneSub(0, 0, pData->rows(), pData->cols() - 1);
	Holder<GMatrix> hFeatures(pFeatures);
	(*pFeatures).print(cout);
    
	GMatrix* pLabels = pData->cloneSub(0, pData->cols() - 1, pData->rows(), 1);
	Holder<GMatrix> hLabels(pLabels);
	(*pLabels).print(cout);
	
	GRand rand(0);
	GDecisionTree model(rand);
	model.train(*pFeatures, *pLabels);
	model.print(cout);
}
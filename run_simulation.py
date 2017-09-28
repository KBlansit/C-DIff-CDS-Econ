#!/usr/bin/env python

# import libraries
import yaml
import random

import numpy as np
import pandas as pd

from multiprocessing import Pool
from numpy.random import triangular

# set global parameters
numpy.random.seed(53845)
random.seed(203876)

NUMB_SIMS = 9999

# functions
def get_new_dict(branch_item_dict):
    # get vals
    vals = list(branch_item_dict.values())

    # assetion
    assert len(vals) == 1

    # return
    return vals[0]

def recusrive_process(dict_head):

    # get branches
    branches = dict_head['BRANCHES']

    # get probs
    prob_branches = [get_new_dict(x)['PROB'] for x in branches]

    # assert probs add up to 1 and we only have 2 items
    assert len(branches) == 2
    assert sum(prob_branches) == 1

    # determine which to use
    if random.uniform(0, 1) >= prob_branches[0]:
        selection = get_new_dict(branches[0])
    else:
        selection = get_new_dict(branches[1])

    # return final cost if we can, otherwise return recusrive_process
    if hasattr(selection, 'COST'):
        return triangle(
            selection['COST']['LOW'],
            selection['COST']['MODE'],
            selection['COST']['HIGH'],
        )
    else:
        recusrive_process(selection)

# primary function
def main():
    # read in data
    with open("parameters.yaml") as f:
    model = yaml.load(f)

    # make top level sims
    model_lst = [model['CDS']] * NUMB_SIMS + [model['NO_CDS']] * NUMB_SIMS

    # make multiprocessing pool
    p = Pool()

    # map function
    storage = p.map(recusrive_process, model_lst)

    # clean up
    p.close()
    p.join()

    # pass to dataframe
    pd.DataFrame({'decision', 'cost'})

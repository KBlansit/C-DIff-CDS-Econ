#!/usr/bin/env python

# import libraries
import yaml
import random

import pandas as pd

def check_cost(branch_item_dict):
    # get vals
    vals = list(branch_item_dict.values())

    # assetion
    assert len(vals) == 1

    # return
    return vals[0]['COST']

def get_prob(branch_item_dict):
    # get vals
    vals = list(branch_item_dict.values())

    # assetion
    assert len(vals) == 1

    # return
    return vals[0]['PROB']


def recusrive_process(dict_head):

    # get branches
    branches = dict_head['BRANCHES']

    # get probs
    prob_branches = [get_prob(x) for x in branches]

    # assert probs add up to 1 and we only have 2 items
    assert len(branches) == 2
    assert sum(prob_branches) == 1

    # determine which to use
    if random.uniform(0, 1) >= prob_branches[0]:
        selection = branches[0]
    else:
        selection = branches[1]

    cost = check_cost(selection)
    if cost is None:
        return recusrive_process(selection)
    else:
        return cost

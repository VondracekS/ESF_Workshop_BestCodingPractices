from abc import abstractmethod

import pandas as pd
import os


class Help:
    def __init__(self):
        pass

def read_csv(self, path: str) -> dict:
    """
    Loads all .csv files present in path into a dictionary
    """
    csv_dict = {}
    for file in os.listdir(path):
        prefix, suffix = file.split(".")
        if suffix == "csv":
            csv_dict[prefix] = pd.read_csv(os.path.join(path, file))
    return csv_dict

def read_csv_v2(self, path: str) -> dict:
    """
    Just like read_csv but removes padding
    """
    csv_dict = {}
    for file in os.listdir(path):
        prefix, suffix = file.split(".")
        if suffix == "csv":
            csv_dict[str(int(prefix))] = pd.read_csv(os.path.join(path, file))
    return csv_dict

def read_csv_v3(self, path: str) -> dict:
    """
    Removes padding using another function
    """
    csv_dict = {}
    for file in os.listdir(path):
        prefix, suffix = file.split(".")
        if suffix == "csv":
            csv_dict[self.remove_padding(prefix)] = pd.read_csv(os.path.join(path, file))
    return csv_dict

def read_csv_v4(self, path: str, file_subset=None) -> dict:
    """
    Makes it possible to load only a subset of the data
    """
    csv_dict = {}
    for file in os.listdir(path):
        prefix, suffix = file.split(".")
        if suffix == "csv":
            if file_subset is None or file in file_subset:
                csv_dict[self.remove_padding(prefix)] = pd.read_csv(os.path.join(path, file))
    return csv_dict

def test_read_csv(self, path):
    """
    Test for the read_csv method
    """
    dict_full = self.read_csv(path)
    assert len(dict_full) == len([f for f in os.listdir(path) if ".csv" in f])
    print(f"Tests passed for the test_read_csv({path})")

def remove_padding(self, tgt_string: str) -> str:
    """
    Removes the padding from the file
    """
    str_out = str(int(tgt_string))
    return str_out

def test_remove_padding(self, test_cases=['0125', '1250']):
    assert self.remove_padding(test_cases[0] == '125')
    print(f"remove_pading({test_cases[0]}) -> {self.remove_padding(test_cases[0])} Test OK")
    assert self.remove_padding(test_cases[1] == '1250')
    print(f"remove_pading({test_cases[1]}) -> {self.remove_padding(test_cases[1])} Test OK")

def get_minmax_date(self, df):

    df['Date'] = pd.to_datetime(df['Date'])
    min_d, max_d = (min(df['Date']), max(df['Date']))

    df_out = pd.DataFrame({'id': [df["ID"].values[0]],
                           'min_d': [min_d],
                           'max_d': [max_d],
                           'days_diff': [(max_d - min_d).days]})
    return df_out

def concat_date_ranges(self, dfs_all, subset=None):

    date_ranges = []

    for k, v in dfs_all.items():
        if subset == None or k in subset:
            date_ranges.append(self.get_minmax_date(v))

    return pd.concat(date_ranges).sort_values('id')
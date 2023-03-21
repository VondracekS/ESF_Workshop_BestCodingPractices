import os
import pandas as pd
import seaborn as sns


def read_csv(path: str) -> dict:
    """
    Loads all .csv files present in path into a dictionary
    """
    csv_dict = {}
    for file in os.listdir(path):
        prefix, suffix = file.split(".")
        if suffix == "csv":
            csv_dict[prefix] = pd.read_csv(os.path.join(path, file))
    return csv_dict


def read_csv_v2(path: str) -> dict:
    """
    Just like read_csv but removes padding
    """
    csv_dict = {}
    for file in os.listdir(path):
        prefix, suffix = file.split(".")
        if suffix == "csv":
            csv_dict[str(int(prefix))] = pd.read_csv(os.path.join(path, file))
    return csv_dict


def read_csv_v3(path: str) -> dict:
    """
    Removes padding using another function
    """
    csv_dict = {}
    for file in os.listdir(path):
        prefix, suffix = file.split(".")
        if suffix == "csv":
            csv_dict[remove_padding(prefix)] = pd.read_csv(os.path.join(path, file))
    return csv_dict


def read_csv_v4(path: str, id_list=None) -> dict:
    """
    Makes it possible to load only a subset of the data
    """
    csv_dict = {}
    files_listed = [f"{station.zfill(3)}.csv" for station in id_list]
    for file in os.listdir(path):
        prefix, suffix = file.split(".")
        if suffix == "csv":
            if id_list is None or file in files_listed:
                csv_dict[remove_padding(prefix)] = pd.read_csv(os.path.join(path, file))
    return csv_dict


def test_read_csv(path):
    """
    Test for the read_csv method
    """
    dict_full = read_csv(path)
    assert len(dict_full) == len([f for f in os.listdir(path) if ".csv" in f])
    print(f"Tests passed for the test_read_csv({path})")


def remove_padding(tgt_string: str) -> str:
    """
    Removes the padding from the file
    """
    str_out = str(int(tgt_string))
    return str_out


def test_remove_padding(test_cases=['0125', '1250']):
    assert remove_padding(test_cases[0] == '125')
    print(f"remove_pading({test_cases[0]}) -> {remove_padding(test_cases[0])} Test OK")
    assert remove_padding(test_cases[1] == '1250')
    print(f"remove_pading({test_cases[1]}) -> {remove_padding(test_cases[1])} Test OK")


def plot_monitoring_station(df, id_vars=['Date', 'ID'], value_vars=['sulfate', 'nitrate']):
    data_plotted = df.melt(id_vars=id_vars, value_vars=value_vars)
    g = sns.FacetGrid(data_plotted, col='ID', hue='variable', legend_out=True)
    g.map(sns.lineplot, 'Date', 'value')


def get_monitor(station_ids: list, dropna=True, plot=True):
    stations_data = read_csv_v4("./specdata", station_ids)
    stations_data = pd.concat(stations_data.values())
    if dropna:
        stations_data = stations_data.dropna()
    if plot:
        plot_monitoring_station(stations_data)
    return stations_data

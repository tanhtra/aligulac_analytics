if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import os

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "/home/src/keys/mage-key.json"

project_id = 'aligulac-dezc'
bucket_name = 'aligulac_datalake'

table_name = 'raw_matches'

root_path = f'{bucket_name}/{table_name}'

@data_exporter
def export_data(data, *args, **kwargs):

    data['period_bins'] = pd.qcut(data['period_id'], q=20)

    table = pa.Table.from_pandas(data)

    gcs = pa.fs.GcsFileSystem()

    pq.write_to_dataset(
        table,
        root_path = root_path,
        partition_cols=['period_bins'],
        filesystem=gcs
    )
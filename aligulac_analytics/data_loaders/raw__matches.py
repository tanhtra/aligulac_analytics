from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from os import path
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

import pyarrow as pa
import pyarrow.parquet as pq
import os

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "/home/src/keys/mage-key.json"

project_id = 'aligulac-dezc'
bucket_name = 'aligulac_datalake'

table_name = 'raw_matches'

root_path = f'{bucket_name}/{table_name}'

@data_loader
def load_from_google_cloud_storage(*args, **kwargs):

    gcs = pa.fs.GcsFileSystem()

    df = pq.read_table(
        source = root_path,
        filesystem=gcs
    ).to_pandas()

    return df

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
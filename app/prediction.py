# For sample predict functions for popular libraries visit https://github.com/opendatahub-io/odh-prediction-samples

# Import libraries
import pandas as pd
import cloudpickle as cp


# Load your model.
pipeline = cp.load(open('pipeline.pkl', 'rb'))


def predict(args_dict):

    d = {'timestamp':0, 'label':0, 'user_id': args_dict.get('user_id'), 'amount': args_dict.get('amount'), 'merchant_id': args_dict.get('merchant_id'), 'trans_type': args_dict.get('trans_type'), 'foreign': args_dict.get('foreign'), 'interarrival': args_dict.get('interarrival')}
    
    df = pd.DataFrame(d, index=[0])
    prediction = pipeline.predict(df)[0]

    return {'prediction': prediction}




import base64
import binascii
import datetime
import hashlib
import hmac
import re

import boto3
import os
import six

region = 'us-east-1'
clientId = "66houh72qh375t5s336cslnfmi"
userPoolId = 'us-east-1_Dxr1V0dC5'
username = "rafiya"
password = "Rafiya123!"

cognito = boto3.client('cognito-idp', region)

n_hex = 'FFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD1' + '29024E088A67CC74020BBEA63B139B22514A08798E3404DD' + \
        'EF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245' + 'E485B576625E7EC6F44C42E9A637ED6B0BFF5CB6F406B7ED' + \
        'EE386BFB5A899FA5AE9F24117C4B1FE649286651ECE45B3D' + 'C2007CB8A163BF0598DA48361C55D39A69163FA8FD24CF5F' + \
        '83655D23DCA3AD961C62F356208552BB9ED529077096966D' + '670C354E4ABC9804F1746C08CA18217C32905E462E36CE3B' + \
        'E39E772C180E86039B2783A2EC07A28FB5C55DF06F4C52C9' + 'DE2BCBF6955817183995497CEA956AE515D2261898FA0510' + \
        '15728E5A8AAAC42DAD33170D04507A33A85521ABDF1CBA64' + 'ECFB850458DBEF0A8AEA71575D060C7DB3970F85A6E1E4C7' + \
        'ABF5AE8CDB0933D71E8C94E04A25619DCEE3D2261AD2EE6B' + 'F12FFA06D98A0864D87602733EC86A64521F2B18177B200C' + \
        'BBE117577A615D6C770988C0BAD946E208E24FA074E5AB31' + '43DB5BFCE0FD108E4B82D120A93AD2CAFFFFFFFFFFFFFFFF'

g_hex = '2'


def hash_sha256(buf):
    """AuthenticationHelper.hash"""
    a = hashlib.sha256(buf).hexdigest()
    return (64 - len(a)) * '0' + a


def hex_hash(hex_string):
    return hash_sha256(bytearray.fromhex(hex_string))
    
def hex_to_long(hex_string):
    return int(hex_string, 16)

def long_to_hex(long_num):
    return '%x' % long_num

def get_random(nbytes):
    random_hex = binascii.hexlify(os.urandom(nbytes))
    return hex_to_long(random_hex)

big_n = hex_to_long(n_hex)
g = hex_to_long(g_hex)
k = hex_to_long(hex_hash('00' + n_hex + '0' + g_hex))

def generate_random_small_a():
  
    random_long_int = get_random(128)
    return random_long_int % big_n

small_a_value = generate_random_small_a()


def calculate_a():

    big_a = pow(g, small_a_value, big_n)
    return big_a

large_a_value = calculate_a()

def get_auth_params():
    auth_params = {'USERNAME': username,
        'SRP_A': long_to_hex(large_a_value)}
    return auth_params

auth_params = get_auth_params()
print("Authentication Parameters: ")
print(auth_params)
print("--------------------------------------------------------------------------------------------------")
print("--------------------------------------------------------------------------------------------------")

response = cognito.initiate_auth(
    AuthFlow='USER_SRP_AUTH',
    AuthParameters=auth_params,
    ClientId=clientId
)
print("Response of Initiate auth call: ")
print(response)
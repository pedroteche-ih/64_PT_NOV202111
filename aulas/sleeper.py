def my_sleep_from_file(x):
    '''
    Sleeps for x-seconds and returns the result x
    '''
    import time
    print(f'Sleeping for {x} seconds.')
    time.sleep(x)
    print(f'Returning {x}')
    return x
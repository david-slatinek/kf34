from __init__ import app
from os import environ
import models

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=int(environ.get('PORT', 5000)))

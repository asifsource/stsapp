from fastapi import FastAPI, Request
from datetime import datetime
import pytz

app = FastAPI()

@app.get("/")
async def get_time(request: Request):
    # Get current UTC time
    utc_time = datetime.utcnow()
    
    # Convert to IST
    ist_tz = pytz.timezone('Asia/Kolkata')
    ist_time = utc_time.replace(tzinfo=pytz.UTC).astimezone(ist_tz)
    
    return {
        "timestamp": ist_time.isoformat(),
        "ip": request.client.host
    }

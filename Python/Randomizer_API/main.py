import random
from typing import Annotated

from fastapi import FastAPI, HTTPException, Query

app = FastAPI()


@app.get("/")
def home():
    return {"message": "Welcome to the Randomizer API!"}


@app.get("/random/{max_value}")
def get_random_number(max_value: int):
    return {"max_value": max_value, "random_number": random.randint(1, max_value)}


@app.get("/random-between/")
def get_random_number_between(
    min_value: Annotated[
        int,
        Query(
            title="Minimum Value",
            description="The minimum  random number",
            ge=1,
            le=1000,
        ),
    ] = 1,
    max_value: Annotated[
        int,
        Query(
            title="Maximum Value",
            description="The maximum  random number",
            ge=1,
            le=1000,
        ),
    ] = 1000,
):
    if min_value > max_value:
        raise HTTPException(
            status_code=400,
            detail="Minimum value must be less than or equal to maximum value.",
        )

    return {
        "min_value": min_value,
        "max_value": max_value,
        "random_number": random.randint(min_value, max_value),
    }

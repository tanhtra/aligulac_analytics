import streamlit as st
import pandas as pd

from google.oauth2 import service_account
from google.cloud import bigquery

# Create API client.
credentials = service_account.Credentials.from_service_account_info(
    st.secrets["gcp_service_account"]
)
client = bigquery.Client(credentials=credentials)

# Perform query.
# Uses st.cache_data to only rerun when the query changes or after 10 min.
@st.cache_data(ttl=600)
def run_query(query):
    df = pd.read_gbq(query, credentials=credentials)
    return df


st.markdown("# Starcraft 2 Match Analytics")
st.markdown("##### Powered by Aligulac.com")

st.markdown("### Whats a Starcraft?")
st.markdown("""
            Starcraft 2 is a real-time strategy game developed by a company formerly known as Blizzard.  
            The game currently has three expansions and still have a relatively active "e-sports" scene.
            """)

st.markdown("### It's not a dead game")
st.markdown("""
            The chart below shows the match activities 
            tracked by [Aligulac](http://www.aligulac.com) noting that there have 
            always been a relatively constant stream of events for professionals to partake in.

            It has however been awhile since the last expansion was released.
            """)

query = """
    SELECT  
        match_year,
        match_expansion,
        SUM(match_count) AS total_matches
    FROM `aligulac-dezc.gold.match_intensity` 
    WHERE match_year != 2024
    GROUP BY match_year, match_expansion
    ORDER BY match_year, match_expansion
    LIMIT 1000
"""
df = run_query(query)

st.area_chart(df, x='match_year', y='total_matches', color='match_expansion', use_container_width=True)

# st.dataframe(df)

st.markdown("### The top players (2020 onwards)")
st.markdown("""
            The chart below shows the top SC2 pro-gamer's tally of winnings (in USD)

            Serral from Finland seems to dominate the current landscape with various South Korean players and Reynor not too far behind.

            """)

query = """
    SELECT  
        player_tag,
        player_country,
        SUM(monthly_total) AS total_winnings

    FROM `aligulac-dezc.gold.total_earnings` 
    WHERE start_year IS NOT NULL
        AND start_year > 2020
    GROUP BY player_country, player_tag
    ORDER BY total_winnings DESC
    LIMIT 20
"""
df = run_query(query)

st.bar_chart(df, x='player_tag', y='total_winnings', color='player_country', use_container_width=True)

query = """
    SELECT  
        player_country AS country,
        SUM(monthly_total) AS total_winnings
    FROM `aligulac-dezc.gold.total_earnings` 
    WHERE start_year IS NOT NULL
        AND start_year > 2020
    GROUP BY player_country
    ORDER BY total_winnings DESC
    LIMIT 10
"""
df = run_query(query)

st.bar_chart(df, x='country', y='total_winnings', color='country', use_container_width=True)

st.markdown("""
            Yes, Starcraft 2 is very popular in South Korea and the player winnings shows.
            """)

st.markdown("""
            ### Pick a race - any race!

            Starcraft 2 is a game with asymmetric race/unit designs - which means certain picks can have a leg up on others.
            Maps also feature heavily into one's odds of a victory.  But judging by raw match data - there seems to be a lot of P(rotoss) 
            wins overall.
            """)

query = """
    SELECT  
        match_month,
        player_primary_race AS race,
        count(*) AS wins
    FROM `aligulac-dezc.gold.player_intensity` 
    WHERE ratio > 0
    AND match_year = 2023
    AND player_primary_race NOT IN ('R', 'S')
    GROUP BY match_month, player_primary_race
    ORDER BY match_month
"""
df = run_query(query)

st.line_chart(df, x="match_month", y="wins", color="race", use_container_width=True)

st.markdown("""
            This streamlit dashboard is part an end-to-end pipeline for the Data Engineering Zoomcamp capstone project.

            The numbers and comments mentioned in this dashboard may be a bit tongue in cheek.

            Thanks to [Aligulac](http://aligulac.com) for providing the dataset.
            Thanks to the members and contributors of the [Data Engineering Zoomcamp](https://https://github.com/DataTalksClub/data-engineering-zoomcamp) for providing the materials.
            """)
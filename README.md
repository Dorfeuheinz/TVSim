# TvSimulation

This is a task used in the recruitment process to the company MindNexus GmbH. It has multiple purposes:

- ensure all the candidates are judged fairly by comparing the same task
- provides a solid foundation for the technical interview
- gives me understanding of your code style and quality
- hopefully is "fun" and not very long

## Overview

This is a standard Phoenix project without unnecessary things:

- no ecto repo, i18n, mailer, dashboard
- replaced default `/` page by `TvSimulationWeb.SimulationLive`, which is a view you should edit
- it has `instructor` library https://github.com/thmsmlr/instructor_ex preconfigured to use [GROQ](https://console.groq.com/docs/quickstart). It's free (with some rate-limiting in place), very fast, OpenAI-compatible service giving access to many models.
- You should use `llama3-70b-8192` model.

## Starting

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Export GROQ_API_KEY variable in the shell: `export GROQ_API_KEY=...`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Instructions

## Details 
We’re asking you to create a simple simulation of 100 people watching 5 different channels on
TV. Since we’re an AI company, instead of providing a typical dashboard we’d like to ask basic
questions in a natural language.
- 1 second in simulation = 5 minutes in real life
- There are 5 TV channels: ZDF, RTL, ProSieben, Vox, Das Erste
- There are 100 people participating in the study identified by numbers 1-100
- Each participant is simulated by repeatedly:
- randomizing channel (or shutting down TV) and time (from 1 min to 120 min)
- watching that channel (or waiting for starting TV) for a given time
- Every 1 minute statistics are collected about current channel views, saved per
{CHANNEL,USER}
- The study operator should be able to query statistics in natural language. For simplicity,
just a few combinations should be supported now, each returning a single record.
Examples:
- Give me the ID of the user who watches the most / least TV and the time?
- Give me the most / least popular channel, and it’s total watch time

- Answer should be provided in a natural language, for example:
- User 89 watched 123 minutes of TV, which is the most of all users.
- Channel VOX is the most popular, with a cumulative 900 minutes of watch time.
- The UI for asking questions & getting answers is prepared in the starting point, so you
don’t have to spend time on the UI.

- clone this repository
- do all the necessary changes
- push to the PRIVATE github or gitlab repository and give me access. Public repositories won't be accepted!

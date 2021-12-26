---
layout: post
title: "When to use JSONB as column type"
description: A review of different sources on when JSONB is suitable for use.
published: true
future: true
mathjax: true
categories: [Postgres, SQL]
---

Caveat: this note is heavily context dependent. The solution of a given problem is informed by the particular version of a database, the difficulty of implementing a solution and ease of maintaining the solution when in production. Don't be afraid to come up with multiple plans and iterating over the design cycle a few times.

I recently had to design a database table schema for use to store new metrics being produced as part of a new data analytics process. As a softare engineer who is fresh to database schema design I investigated different options for storing data. One of these options was to use the `JSONB` type to store multiple values. This post is a summary of the different knowledge I gleaned from various blog posts.

JSONB can appear to be an attractive choice as it means that there is no requirement to manage the schema of the database. The use of JSONB is apparently a common trap is it can result in multiple undocumented variations of a given schema which are stored in an opaque manner in the database. There are numerous downsides to using JSON for anything other than unstructured blobs of data in a manner similar to NoSQL or JSONs.

# Pros for using JSONB

- No requirement to manage the schema of the database for that column. Potential of falling into the trap of having mutiple undocumented schemas.
- Useful for handling dynamic-column data.
- For storing data which doesn’t fit within the normal relational model. E.g. NoSQL.
- For storing json.

# Cons of using JSONB

- Queries on this format run slowly due to the lack of statistics. Postgres maintains tables of statistics on each column which assist with query planning. These statistics are not maintained for JSONB columns.
- There is no fixed data typing within JSONB columns. This causes conversion problems with saving and extracting data from JSONB entries.
- There are no constraints with saving data into JSONB format. This means that there is more scope for errors to creep in.
- JSONBs can result in a larger table footprint.


# Annotated bibliography

[Heap: When To Avoid JSONB In A PostgreSQL Schema](https://heap.io/blog/engineering/when-to-avoid-jsonb-in-a-postgresql-schema)

- Nice analysis on when JSONB is suitable for use from an organisation which uses this format to store data of arbitrary length, i.e. customer entered data.

[When to Avoid JSONB in a PostgreSQL Schema](https://news.ycombinator.com/item?id=12408634)

- Discussion of the Heap post on hacker news.
- I find it interesting to learn about other peoples experiences, however anecdotal they might be.

[Faster Operations with the JSONB Data Type in PostgreSQL](https://www.compose.com/articles/faster-operations-with-the-jsonb-data-type-in-postgresql/)

- A post describing how to use JSONB faster if you have to use it.

[Explanation of JSONB introduced by PostgreSQL](https://stackoverflow.com/questions/22654170/explanation-of-jsonb-introduced-by-postgresql)

- Good stackoverflow answers are worth their weight in gold.
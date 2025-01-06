# QBcore Society Money Management

This document provides an overview of how to manage the balance for jobs and gangs in your FiveM server using the `qbx_society` resource.

## Prerequisites

Before using the functions outlined below, make sure you have the `qbx_society` resource installed on your FiveM server.

## Functions Overview

The `qbx_society` resource allows you to manage monetary balances for different job types and gangs. Below are examples demonstrating how to use the resource.

### 1. Get the Balance for a Job

To get the current balance for a job, use the `GetMoney` function. This example demonstrates how to fetch the balance for the police job:

```lua
-- Get the balance for a job
local balance = exports.qbx_society:GetMoney("job", "police") 
print("Police job balance: $" .. balance)

-- Get the balance for a gang
local gangBalance = exports.qbx_society:GetMoney("gang", "ballas")
print("Ballas gang balance: $" .. gangBalance)

-- Add $1000 to the police job balance
local successAdd = exports.qbx_society:AddMoney("job", "police", 1000)
if successAdd then
    print("Successfully added money to the police balance!")
else
    print("Failed to add money to the police balance.")
end

-- Deduct $500 from Ballas gang balance
local successRemove = exports.qbx_society:RemoveMoney("gang", "ballas", 500)
if successRemove then
    print("Successfully subtracted money from the Ballas balance!")
else
    print("Insufficient funds or failed to subtract.")
end

-- Check if the police job has sufficient funds
local hasFunds = exports.qbx_society:HasBalance("job", "police", 1500)
if hasFunds then
    print("Police job has sufficient funds.")
else
    print("Police job does not have enough funds.")
end


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

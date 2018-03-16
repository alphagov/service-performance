## Introduction

This document describes the domain model for service performance using
an ML like language (actually F#) to describe the types that are found
within the application, and their relationship to each other. Where
necessary the validation of the types is documented.

The terminology is mostly consistent with the app's models, but those
models should be refactored to more closely follow this domain model.

## Service Performance

Service Performance provides a tool that allows organisations to publish
metrics about their service transactions, and end users to view and track
trends in the data.  The metrics collected revolve around the tracking of
transactions in services, how many they receive, how they're received and
how many of them are processed within a given month.

Each month an organisation is expected to provide metrics for the previous
month.  Some organisations do not collect some metrics, for instance when
they don't have a call centre, they don't provide 'Calls received' metrics.
These are said to be 'Not Provided'.

For any given metric, the range of valid values are shown below.  There is
either a value, the data is not provided, or it is not applicable for this
service.

```fsharp
type NotApplicable = unit
type NotProvided   = unit

type MetricValue =
  | Value of uint
  | NotApplicable
  | NotProvided
```

## Metrics

### Transactions Received

These metrics record the total number of transactions received by a service in a given month, and then a breakdown of the channels on which the transactions were received.  Not all services will receive transactions on all channels, and the other channel allows the capture of channels not currently supported.  There have been discussions about supporting multiple 'other' channels and this would likely require quite a deep restructure of the data model.

```fsharp
type TransactionsReceived = {
  Total: MetricValue,
  Phone: MetricValue,
  Online: MetricValue,
  Paper: MetricValue,
  FaceToFace: MetricValue,
  Other: MetricValue

(*
  Unlike the other group types, we never expect Transaction received
  metrics to be non-applicable because it is the core metric we collect
  and the other don't make any sense without it.
*)
type TransactionsReceivedGroup = TransactionsReceived
```

### Transactions Processed

All services should report the total number of transactions that they have processed during a given month. As well as providing the total, they should also record the number of transactions that resulted in a positive outcome for the user - that is, it met their needs.  There is still some confusion in this area specifically around the semantics of "what does processed mean?" and "what is the users' intended outcome?".

```fsharp
type TransactionsProcessed = {
  Total: MetricValue,
  MetNeeds: MetricValue
}

type TransactionsProcessedGroup =
  | TransactionsProcessed
  | NotApplicable
```

### Calls Received

For those services that receive telephone calls, they are expected to record the appropriate metrics. As telephone is itself a channel, the breakdown of calls instead record the reason for calling.  Total should be the sum of all of the other fields, and PerformTransaction should be the same value as TransactionsReceived.Phone.

```fsharp
type CallsReceived = {
  Total: MetricValue
  PerformTransaction: MetricValue
  ChaseDecision: MetricValue
  Information: MetricValue
  Other: MetricValue
}

type CallsReceivedGroup =
  | CallsReceived
  | NotApplicable
```

### MetricGroups

A metric group is a collection of the different metrics. This is used in many contexts:

* To show metrics for a single service
  * For a single month
  * For a given time-period as an aggregate
* To show metrics for a given delivery organisation. This is an aggregate of all of the services within that delivery organisation.
  * For a single month
  * For a given time-period as an aggregate.
* To show metrics for a given department. This is an aggregate of all of the delivery organisations (and therefore services) within that department.
  * For a single month
  * For a given time-period as an aggregate

```fsharp
type MetricGroup = {
  received: TransactionReceivedGroup,
  processed: TransactionProcessedGroup,
  calls: CallsReceivedGroup
}
```



## Time Periods

The granularity of the time periods we are interested in is a calendar month.  This is the minimum period of time that we collect and show data for. It may later we necessary to collect data more frequently, for instance in near real-time, but this should not affect the underlying model - that data should be assigned to a single month.  Time Periods are used quite widely within Service Performance, and so we have decided to use a short date format to avoid confusion around how many days are within a given month.

```fsharp
type ShortDate = {
  month: uint,
  year: uint,
}

type TimePeriod = {
  starts_on: ShortDate,
  ends_on: ShortDate
}
```



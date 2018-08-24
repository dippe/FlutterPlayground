import 'package:flutter/material.dart';

const DEFAULT_ISSUEKEY_CHAR_WIDTH = 8.0;
const DEFAULT_ISSUEKEY_CHAR_PADDING = 15.0;
const COLOR_UNKNOWN = Colors.grey;
const UNKNOWN_ICON = Icons.blur_on;

const STATUS_CHIP_WIDTH = 50.0;

const STATUS_COLORS = {
  1: Colors.yellow,
  2: Colors.grey,
  3: Colors.green,
  4: Colors.blue,
  5: Colors.red,
};

const ASSET_UNKNOWN_PRIORITY = 'images/issuetypes/blank.png';

const ASSET_DEFAULT_ISSUE_TYPE_ICON = 'images/issuetypes/genericissue.png';

const ASSET_ISSUE_TYPE_ICONS = {
  'Default': 'images/issuetypes/all_unassigned.png',
  'Defect': 'images/issuetypes/defect.png',
  'Story': 'images/issuetypes/story.png',
  'Epic': 'images/issuetypes/epic.png',
  'Task': 'images/issuetypes/task.png',
  'Bug': 'images/issuetypes/bug.png',
  'Sub-task': 'images/issuetypes/subtask.png',
  'Undefined': 'images/issuetypes/undefined.png',
  'Documentation': 'images/issuetypes/documentation.png',
  'Feedback': 'images/issuetypes/feedback.png',
  'Improvement': 'images/issuetypes/improvement.png',
  'Task-agile': 'images/issuetypes/task_agile.png',
  'Blank': 'images/issuetypes/blank.png',
  'Delete': 'images/issuetypes/delete.png',
  'Generic-issue': 'images/issuetypes/genericissue.png',
  'New Feature': 'images/issuetypes/newfeature.png',
  'Requirement': 'images/issuetypes/requirement.png',
  'Subtask-alternate': 'images/issuetypes/subtask_alternate.png',
  'Development-task': 'images/issuetypes/development_task.png',
  'Exclamation': 'images/issuetypes/exclamation.png',
  'Health': 'images/issuetypes/health.png',
  'Remove-feature': 'images/issuetypes/remove_feature.png',
  'Sales': 'images/issuetypes/sales.png',
};

const ASSET_STATUS_ICONS = {
  'done': 'images/statuses/resolved.png',
  'indeterminate': 'images/statuses/inprogress.png',
  'new': 'images/statuses/open.png',
};

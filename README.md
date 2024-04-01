# obsidian-tag-delete is now a plugin

obsidian-tag-delete has evolved from a simple (?) shell script to delete a tag from an Obsidian.md Markdown file into an Obsidian plugin. 
It lives now at <https://github.com/wealthychef1/obsidian-tag-delete-plugin>



## Warning:  this script deletes data from your vault: use at your own risk
- BACK UP FIRST
- I have tested it on my own data and am satisfied it "shouldn't" do any bad things but:
**Always back up your data before running this script**

## Usage
```bash
obsidian-tag-delete.sh -h
```
### Example
```bash
obsidian-tag-delete.sh mytag anothertag myfile.md
```

## Assumptions
Per the [documentation](https://help.obsidian.md/How+to/Working+with+tags), this script assumes tags are in the body of your document in this form:  
```markdown
#mytag
```

Or they can be in the frontmatter (YAML) in this form:  ("Tags" may be "tags")
```yaml
Tags: mytag
```

Or:  
```yaml
# these will all be deleted by the script
Tags: [mytag, mytag, mytag mytag] 
```

But not: 
```yaml
Tags:
 - mytag
```

# obsidian-tag-delete
A simple (?) shell script to delete a tag from an Obsidian.md Markdown file
I'm publishing this here because there is an opportunity to improve it by supporting the YAML use case described in the code.  :-P
Also, so others can freely use it and learn from it.  

## Warning:  this script deletes data from your vault: BACK UP FIRST
I have tested it on my own data and am satisfied it "shouldn't" do any bad things but:
**Always back up your data before running this script**

## Usage
```bash
obsidian-tag-delete.sh -h
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
Tags: [ mytag ] 
```

But not: 
```yaml
Tags:
 - mytag
```

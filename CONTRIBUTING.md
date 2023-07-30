# Updating and publishing images

## Image build and publishing

```
# Step 1 : Log in
docker login --username <your-username>

# Step 2 : Type your password in prompt...

# Locally build the image to be published (use the above tagging convention for tag definition)
docker build -t fabernovel/heart:<tagname> .

# Push image to public registry
docker push fabernovel/heart:<tagname>
```
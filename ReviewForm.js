import React, { useState, useEffect } from 'react';

function ReviewForm({ onSubmit, editingReview, onUpdate }) {
  const [formData, setFormData] = useState({
    bookTitle: '',
    author: '',
    reviewText: '',
    rating: ''
  });

  useEffect(() => {
    if (editingReview) {
      setFormData(editingReview);
    }
  }, [editingReview]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editingReview) {
      onUpdate(editingReview.reviewId, formData);
    } else {
      onSubmit(formData);
    }
    setFormData({
      bookTitle: '',
      author: '',
      reviewText: '',
      rating: ''
    });
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        name="bookTitle"
        placeholder="Book Title"
        value={formData.bookTitle}
        onChange={handleChange}
        required
      />
      <input
        type="text"
        name="author"
        placeholder="Author"
        value={formData.author}
        onChange={handleChange}
        required
      />
      <textarea
        name="reviewText"
        placeholder="Review Text"
        value={formData.reviewText}
        onChange={handleChange}
        required
      />
      <input
        type="number"
        name="rating"
        placeholder="Rating"
        value={formData.rating}
        onChange={handleChange}
        required
      />
      <button type="submit">{editingReview ? 'Update' : 'Submit'}</button>
    </form>
  );
}

export default ReviewForm;